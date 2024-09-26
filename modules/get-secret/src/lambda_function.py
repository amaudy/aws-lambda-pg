import boto3
import json
import logging
from botocore.exceptions import ClientError

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize the Secrets Manager client
secrets_manager = boto3.client('secretsmanager')

def lambda_handler(event, context):
    secret_name = "rds/postgresql/db_password"
    
    try:
        # Retrieve the secret
        get_secret_value_response = secrets_manager.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        logger.error(f"Error retrieving secret: {e}")
        raise e
    else:
        # Decode the secret if it's a binary secret
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary']).decode('utf-8')
        
        # Try to parse the secret as JSON, if it fails, assume it's a plain string
        try:
            secret_dict = json.loads(secret)
            db_password = secret_dict.get('db_password')
        except json.JSONDecodeError:
            # If it's not JSON, assume the entire secret is the password
            db_password = secret
        
        # Log the password (be cautious about logging sensitive information in production)
        logger.info(f"Retrieved db_password: {db_password}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Secret retrieved successfully')
        }