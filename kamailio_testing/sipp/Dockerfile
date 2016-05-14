FROM ubuntu:14.04

MAINTAINER Giacomo Vacca "giacomo.vacca@gmail.com"

RUN apt-get update \
    && apt-get -y -q install sip-tester ngrep tcpdump telnet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/sipp
WORKDIR /root/sipp
