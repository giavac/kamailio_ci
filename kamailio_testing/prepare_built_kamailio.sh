#!/bin/sh

set -x

echo "USAGE: $0 [TEST_USER(gvacca)] [TEST_DISTRIBUTION(centos7)] [KAMAILIO_SRC(~/git/kamailio-devel/kamailio)] [GIT_REF(master)]"

PROJECT=kamailiotesting
KAMAILIO_BIN=/usr/local/sbin/kamailio

TEST_USER=${1-'gvacca'}
export TEST_USER

TEST_DISTRIBUTION=${2-'centos7'}
export TEST_DISTRIBUTION

KAMAILIO_SRC=${3-~/git/kamailio-devel/kamailio}
GIT_REF=${4-'master'}

PROJECT_DIR=$(pwd)

# git checkout the desired git reference
cd ${KAMAILIO_SRC}
git checkout ${GIT_REF}
git pull
KAMA_VERSION=$(git describe --always)

BUILT_KAMAILIO=kamailio_async_built_${TEST_DISTRIBUTION}_${KAMA_VERSION}
TEST_IMAGE=${TEST_USER}/kamailio_async:${TEST_DISTRIBUTION}_${KAMA_VERSION}
export TEST_IMAGE

cd ${PROJECT_DIR}

docker stop ${BUILT_KAMAILIO}
docker rm ${BUILT_KAMAILIO}
docker run -t --name ${BUILT_KAMAILIO} -v ${KAMAILIO_SRC}:/root/kamailio -v $PWD/kamailio_async_${TEST_DISTRIBUTION}/scripts:/root/scripts ${TEST_USER}/kamailio_async:${TEST_DISTRIBUTION} /root/scripts/build.sh
docker commit ${BUILT_KAMAILIO} ${TEST_IMAGE}

echo "Image for running tests: ${TEST_IMAGE}"
