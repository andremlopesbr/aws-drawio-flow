import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Lambda function executed successfully!",
            "input": event
        })
    }
