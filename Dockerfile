FROM public.ecr.aws/lambda/python:3.11

# Copy requirements.txt
COPY modules/pingdb/src/requirements.txt ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install -r requirements.txt

# Copy function code
COPY modules/pingdb/src/ ${LAMBDA_TASK_ROOT}

# Create ZIP file
RUN zip -r /lambda_function.zip .

# Set the CMD to your handler
CMD ["lambda_function.lambda_handler"]