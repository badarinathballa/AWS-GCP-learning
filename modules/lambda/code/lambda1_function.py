import json
import boto3
import os
from decimal import Decimal
from boto3.dynamodb.types import TypeDeserializer

# ─── CONFIG ────────────────────────────────────────────
SQS_QUEUE_URL = os.environ['SQS_QUEUE_URL']
AWS_REGION    = os.environ['AWS_REGION_NAME']

class DecimalEncoder(json.JSONEncoder):
    """Handle Decimal types from DynamoDB number fields"""
    def default(self, obj):
        if isinstance(obj, Decimal):
            # Convert to int if whole number else float
            return int(obj) if obj % 1 == 0 else float(obj)
        return super().default(obj)

def deserialize_item(item):
    """Convert DynamoDB JSON format to normal Python dict"""
    deserializer = TypeDeserializer()
    return {k: deserializer.deserialize(v) for k, v in item.items()}

def lambda_handler(event, context):
    sqs       = boto3.client('sqs', region_name=AWS_REGION)
    processed = 0

    print(f"Received {len(event['Records'])} records from DynamoDB stream")

    for record in event['Records']:
        event_name = record['eventName']
        print(f"Processing event: {event_name}")

        message = {
            'event_name': event_name,
            'table':      record['eventSourceARN'].split('/')[1],
        }

        if 'NewImage' in record['dynamodb']:
            new_record = deserialize_item(record['dynamodb']['NewImage'])
            message['new_record'] = new_record
            # Use DecimalEncoder for printing
            print(f"New record: {json.dumps(new_record, cls=DecimalEncoder)}")

        if 'OldImage' in record['dynamodb']:
            old_record = deserialize_item(record['dynamodb']['OldImage'])
            message['old_record'] = old_record
            print(f"Old record: {json.dumps(old_record, cls=DecimalEncoder)}")

        # Use DecimalEncoder when sending to SQS too!
        response = sqs.send_message(
            QueueUrl    = SQS_QUEUE_URL,
            MessageBody = json.dumps(message, cls=DecimalEncoder)
        )
        print(f"Sent to SQS MessageId: {response['MessageId']}")
        processed += 1

    print(f"Successfully processed {processed} records")
    return {'statusCode': 200, 'processed': processed}