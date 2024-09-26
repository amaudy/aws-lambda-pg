import boto3
import json
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

secrets_manager = boto3.client('secretsmanager')

def lambda_handler(event, context):
    secret_name = "rds/postgresql/db_password"
    
    try:
        get_secret_value_response = secrets_manager.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        logger.error(f"Error retrieving secret: {e}")
        raise e
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary']).decode('utf-8')
        
        try:
            secret_dict = json.loads(secret)
            db_password = secret_dict.get('db_password')
        except json.JSONDecodeError:
            db_password = secret
        
        logger.info(f"Retrieved db_password: {db_password}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Secret retrieved successfully')
        }