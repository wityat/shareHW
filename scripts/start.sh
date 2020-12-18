#!/bin/bash

dd if=/dev/zero of=/home/file count=1 bs=100M
mkfs.ext4 /home/file
mount -o loop /home/file /usr/files

envsubst < /etc/nginx/conf.d/service.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;' &
cron -f &
smbd --foreground --no-process-group
