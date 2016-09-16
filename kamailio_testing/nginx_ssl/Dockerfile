FROM ubuntu:14.04

MAINTAINER Giacomo Vacca "giacomo.vacca@gmail.com"

ENV REFRESHED_AT 2016-01-04

RUN apt-get update \
    && apt-get -y -q install nginx apache2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

COPY nginx/global.conf /etc/nginx/conf.d/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/htpasswd /etc/nginx/.htpasswd

RUN mkdir -p /etc/nginx/ssl
# Expect from volume:
# /etc/nginx/ssl/nginx.crt
# /etc/nginx/ssl/nginx.key
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost"

EXPOSE 80
EXPOSE 443

CMD nginx
