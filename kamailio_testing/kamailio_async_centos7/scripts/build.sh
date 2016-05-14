#!/bin/sh
cd /root/kamailio
make distclean
make cfg include_modules=http_async_client
make all && make install
