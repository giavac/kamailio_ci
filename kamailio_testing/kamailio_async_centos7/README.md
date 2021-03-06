# Base build image for Kamailio on CentOS

Build the base image for building Kamailio on CentOS 7:
```
docker build -t USER/kamailio_async:centos7 -f Dockerfile.centos7 .
```

Run a container on top of the base image:
```
docker run -it -v $PATHTOKAMAILIOSRC/kamailio:/root/kamailio USER/kamailio_async:centos7 bash
```

From inside the container:

```
cd /root/kamailio
make distclean && make cfg && make all && make install
/usr/local/sbin/kamailio -f /usr/local/etc/kamailio/kamailio.cfg -DD -E -e
```
or execute `build_run.sh`.
