FROM nginx

COPY scripts /usr/scripts
COPY scripts/crontab /etc/cron.d/cjob
RUN chmod 0644 /etc/cron.d/cjob
WORKDIR /usr/scripts

COPY files /usr/files
RUN rm /etc/nginx/conf.d/default.conf
COPY scripts/service.template /etc/nginx/conf.d

RUN apt-get update && apt-get install -y samba
RUN cp smb.conf /etc/samba/smb.conf

CMD bash start.sh
