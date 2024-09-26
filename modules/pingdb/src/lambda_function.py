import os
import psycopg2
import json
import boto3
from botocore.exceptions import ClientError

def get_secret():
    secret_name = os.environ['SECRET_NAME']
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        raise e
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
            return json.loads(secret)['db_password']
        else:
            raise ValueError("Secret not found in SecretString")

def lambda_handler(event, context):
    host = os.environ['DB_HOST']
    dbname = os.environ['DB_NAME']
    user = os.environ['DB_USER']
    
    try:
        password = get_secret()
        
        conn = psycopg2.connect(
            host=host,
            dbname=dbname,
            user=user,
            password=password
        )
        cur = conn.cursor()
        cur.execute('SELECT version()')
        db_version = cur.fetchone()
        cur.close()
        conn.close()
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Successfully connected to the database. PostgreSQL version: {db_version[0]}')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Unable to connect to the database: {str(e)}')
        }