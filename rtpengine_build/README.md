# Prepare base image

docker build -t gvacca/rtpengine:centos -f Dockerfile .

# Prepare source code
cd SRC
git clone https://github.com/sipwise/rtpengine
git checkout TAG

# Build rtpengine
cd THISPROJECT
docker rm rtpengine_built
docker run -t --name rtpengine_built -v $PWD/:/root -v ~/git/rtpengine/rtpengine:/root/rtpengine gvacca/rtpengine:centos /root/build.sh

docker images |grep rtpengine
