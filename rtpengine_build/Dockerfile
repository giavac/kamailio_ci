FROM centos:7

MAINTAINER Giacomo Vacca <giacomo.vacca@gmail.com>

RUN yum install -y make glib2-devel zlib-devel kmod hiredis-devel \
                   openssl-devel xmlrpc-c-devel iptables-devel libevent-devel \
                   libevent2-devel git \
    && yum clean all

# Get source code via a volume
RUN mkdir -p /root/rtpengine
VOLUME ["/root/rtpengine/"]
WORKDIR /root/rtpengine
