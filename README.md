# MOSIP_20_Credit

docker build -t nginx-with-minio-client .

docker run -p 80:80 --name nm --env="TZ=Asia/Kolkata" --volume="/etc/timezone:/etc/timezone:ro" -e MC_SERVER_URL=<url> -e MC_ACCESS_KEY=<access_key> -e MC_SECRET_KEY=<secret_key> -e MC_BUCKETS=<reports> -d nginx-with-minio-client

docker exec -it nm /bin/bash

ls /usr/share/nginx/html


