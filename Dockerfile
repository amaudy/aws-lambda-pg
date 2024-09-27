FROM public.ecr.aws/lambda/python:3.11

RUN yum update -y && \
    yum install -y postgresql postgresql-devel gcc zip && \
    yum clean all && \
    rm -rf /var/cache/yum

# Copy requirements.txt
COPY modules/pingdb/src/requirements.txt ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install -r requirements.txt -t modules/pingdb/src
RUN cp /usr/lib64/libpq.so.5 modules/pingdb/src/ && \
    cp /usr/lib64/libldap_r-2.4.so.2 modules/pingdb/src/ && \
    cp /usr/lib64/liblber-2.4.so.2 modules/pingdb/src/ && \
    cp /usr/lib64/libsasl2.so.3 modules/pingdb/src/ && \
    cp /usr/lib64/libssl3.so modules/pingdb/src/ && \
    cp /usr/lib64/libsmime3.so modules/pingdb/src/ && \
    cp /usr/lib64/libnss3.so modules/pingdb/src/

    # Copy function code
COPY modules/pingdb/src/ ${LAMBDA_TASK_ROOT}

# Create ZIP file
RUN zip -r /lambda_function.zip .

# Set the CMD to your handler
CMD ["lambda_function.lambda_handler"]