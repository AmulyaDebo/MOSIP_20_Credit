#!/bin/bash

# Source the user's profile
source /root/.bashrc  # Adjust the path as needed

# Set MinIO configuration using environment variables
MC_SERVER_URL="${MC_SERVER_URL}"
MC_ACCESS_KEY="${MC_ACCESS_KEY}"
MC_SECRET_KEY="${MC_SECRET_KEY}"
MC_BUCKETS="${MC_BUCKETS}"
DESTINATION_DIR="${DESTINATION_DIR:-/usr/share/nginx/html/reports}"

# Check if required variables are set
if [ -z "$MC_SERVER_URL" ] || [ -z "$MC_ACCESS_KEY" ] || [ -z "$MC_SECRET_KEY" ]; then
  echo "ERROR: Missing required MinIO configuration variables."
  exit 1
fi

# Set up MinIO alias
/usr/local/bin/mc config host add newminio "$MC_SERVER_URL" "$MC_ACCESS_KEY" "$MC_SECRET_KEY" --api S3v4

# Verify the 'newminio' alias
/usr/local/bin/mc alias ls

# Display the MinIO server information
/usr/local/bin/mc admin info newminio

# Iterate over each bucket
IFS=',' read -ra BUCKET_ARRAY <<< "$MC_BUCKETS"
for BUCKET in "${BUCKET_ARRAY[@]}"; do
  # Download files from MinIO for each bucket
  /usr/local/bin/mc cp -r newminio/"$BUCKET"/auth/ "$DESTINATION_DIR"
done
