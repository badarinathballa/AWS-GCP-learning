import json
import boto3
import os
from datetime import datetime, timezone
from google.cloud import storage
from google.oauth2 import service_account

# ─── CONFIG ────────────────────────────────────────────
AWS_REGION      = os.environ['AWS_REGION_NAME']
SECRET_NAME     = os.environ['SECRET_NAME']
GCS_BUCKET_NAME = os.environ['GCS_BUCKET_NAME']

def get_gcp_credentials():
    """Fetch GCP service account key from Secrets Manager"""
    print("Fetching GCP credentials from Secrets Manager...")
    client   = boto3.client('secretsmanager', region_name=AWS_REGION)
    secret   = client.get_secret_value(SecretId=SECRET_NAME)
    key_json = json.loads(secret['SecretString'])
    credentials = service_account.Credentials.from_service_account_info(key_json)
    print("GCP credentials fetched successfully!")
    return credentials

def get_employee_id(message):
    """
    Safely extract employee_id from message.
    Handles both normal string and nested dict just in case.
    """
    try:
        if 'new_record' in message:
            emp_id = message['new_record'].get('employee_id', 'unknown')
        elif 'old_record' in message:
            emp_id = message['old_record'].get('employee_id', 'unknown')
        else:
            return 'unknown'

        # Safety check — if still dict extract value
        if isinstance(emp_id, dict):
            emp_id = list(emp_id.values())[0]

        # Clean — remove special characters that break GCS paths
        return str(emp_id).strip().replace(' ', '_').replace('/', '_')

    except Exception as e:
        print(f"Could not extract employee_id: {e}")
        return 'unknown'

def upload_to_gcs(data, file_name, credentials):
    """Upload JSON data to GCS bucket"""
    client = storage.Client(credentials=credentials)
    bucket = client.bucket(GCS_BUCKET_NAME)
    blob   = bucket.blob(file_name)
    blob.upload_from_string(
        json.dumps(data, indent=2, default=str),
        content_type='application/json'
    )
    print(f"Uploaded → gs://{GCS_BUCKET_NAME}/{file_name}")

def lambda_handler(event, context):
    """
    Triggered by SQS.
    Reads messages and uploads each record to GCS.
    """
    print(f"Received {len(event['Records'])} messages from SQS")

    # ─── Fetch GCP credentials ONCE for all messages ───
    credentials = get_gcp_credentials()
    processed   = 0

    for record in event['Records']:

        # ─── Parse SQS message body ─────────────────────
        message    = json.loads(record['body'])
        event_name = message.get('event_name', 'UNKNOWN')
        table      = message.get('table', 'unknown-table')

        print(f"Processing {event_name} event for table: {table}")
        print(f"Message content: {json.dumps(message)}")

        # ─── Extract employee_id safely ─────────────────
        employee_id = get_employee_id(message)
        print(f"Employee ID: {employee_id}")

        # ─── Build clean GCS file path ──────────────────
        timestamp = datetime.now(timezone.utc).strftime('%Y%m%d_%H%M%S_%f')
        file_name = f"{table}/{event_name}/{employee_id}_{timestamp}.json"
        print(f"File path: {file_name}")

        # ─── Build data payload ─────────────────────────
        data = {
            'event':     event_name,
            'table':     table,
            'timestamp': datetime.now(timezone.utc).isoformat(),
            'data':      message
        }

        # ─── Upload to GCS ──────────────────────────────
        upload_to_gcs(data, file_name, credentials)
        processed += 1

    print(f"Successfully uploaded {processed} records to GCS")
    return {'statusCode': 200, 'processed': processed}