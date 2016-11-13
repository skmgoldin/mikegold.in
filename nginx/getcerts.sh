#!/bin/bash

nohup nginx -c /init-nginx.conf &
certbot certonly -n --agree-tos --email skmgoldin@gmail.com --webroot -w /usr/share/nginx/html -d hidden.computer -d www.hidden.computer
nginx -s stop
echo "@daily certbot renew" > /crontab.file
crontab /crontab.file
nginx -c /next-nginx.conf -g "daemon off;"
