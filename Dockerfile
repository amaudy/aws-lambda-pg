FROM public.ecr.aws/lambda/python:3.11

RUN yum update -y && yum install -y postgresql-devel gcc zip

# Copy requirements.txt
COPY modules/pingdb/src/requirements.txt ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install -r requirements.txt -t modules/pingdb/src

# Copy function code
COPY modules/pingdb/src/ ${LAMBDA_TASK_ROOT}

# Create ZIP file
RUN zip -r /lambda_function.zip .

# Set the CMD to your handler
CMD ["lambda_function.lambda_handler"]