#!/bin/bash

# Define the directory where the downloaded files are stored
DOWNLOAD_DIR="/usr/share/nginx/html"

# Find files older than 50 days and delete them
find "$DOWNLOAD_DIR" -type f -mtime +50 -exec rm {} \;

# Optionally, you can log the deleted files
# You can uncomment the following line and specify a log file if needed
# find "$DOWNLOAD_DIR" -type f -mtime +50 -exec rm {} \; | tee -a /var/log/deleted_files.log
