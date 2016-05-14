#!/bin/bash

KERNEL_VERSION=3.10.0-327.4.4.el7.x86_64

# Note: we install gcc here and not in the build image
# because otherwise it would have already pulled the kernel headers
yum install -y kernel-devel-${KERNEL_VERSION} kernel-headers-${KERNEL_VERSION} gcc && yum clean all

echo "ls -la /usr/src/kernels/"
ls -la /usr/src/kernels/

cd /root/rtpengine

echo "build_rtpengine: start"
rtpengine_version=$(git describe --tags --always)-${KERNEL_VERSION}
rm -f VERSION
make -C daemon clean
make -C daemon RTPENGINE_VERSION=$rtpengine_version
        
make -C iptables-extension clean
make -C iptables-extension RTPENGINE_VERSION=$rtpengine_version
        
make -C kernel-module KSRC=/usr/src/kernels/${KERNEL_VERSION} clean
make -C kernel-module KSRC=/usr/src/kernels/${KERNEL_VERSION} RTPENGINE_VERSION=$rtpengine_version

/sbin/modinfo kernel-module/xt_RTPENGINE.ko
        
echo -n $rtpengine_version > VERSION
echo "build_rtpengine: done"
