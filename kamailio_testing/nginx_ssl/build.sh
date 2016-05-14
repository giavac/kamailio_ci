#!/bin/sh

CN=192.168.99.100

mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout nginx/ssl/nginx.key -out nginx/ssl/nginx.crt -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=${CN}"

docker build -t gvacca/nginx_ssl .
