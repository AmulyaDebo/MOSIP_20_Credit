# Use an official Nginx image as the base
FROM nginx:latest

ENV TZ=Asia/Kolkata

# Install any required dependencies here
RUN apt-get update && apt-get install -y wget



RUN ln -snf /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime && echo $(cat /etc/timezone) > /etc/timezone

COPY nginx.conf /etc/nginx

COPY index.php /usr/share/nginx/html




# Check if the MinIO client is already installed
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && chmod +x /usr/local/bin/mc

# Make the script executable
COPY minio_download_script.sh /usr/local/bin/minio_download_script.sh
RUN chmod +x /usr/local/bin/minio_download_script.sh

# Install cron
RUN apt-get update && apt-get install -y cron

# Add a cron job file to schedule the MinIO download script
COPY cronjob /etc/cron.d/minio_download
RUN chown root:root /etc/cron.d/minio_download
RUN chmod 0644 /etc/cron.d/minio_download
RUN crontab /etc/cron.d/minio_download

# Install supervisord
RUN apt-get update && apt-get install -y supervisor

# Add a supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf



# Start supervisord
CMD ["/usr/bin/supervisord"]
