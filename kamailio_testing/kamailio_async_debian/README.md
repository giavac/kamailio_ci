# Base build image for Kamailio on Debian

Build the base image for building Kamailio debian (jessie):

```
docker build -t USER/kamailio_async:debian -f Dockerfile.debian .
```

Run a container on top of the base image:

```
docker run -it -v $PATHTOKAMAILIOSRC/kamailio:/root/kamailio USER/kamailio_async:debian bash
```


From inside the container:

```
cd /root/kamailio
make distclean && make cfg && make all && make install
/usr/local/sbin/kamailio -f /usr/local/etc/kamailio/kamailio.cfg -DD -E -e
```
or execute `build_run.sh`, which does the same.
