#!/bin/sh

set -x

echo "USAGE: $0 TEST_IMAGE [TEST_USER(gvacca)] [TEST_DISTRIBUTION(centos7)]"

TEST_IMAGE=$1
export TEST_IMAGE

TEST_USER=${2-'gvacca'}
export TEST_USER

TEST_DISTRIBUTION=${3-'centos7'}
export TEST_DISTRIBUTION

PROJECT=kamailiotesting
KAMAILIO_BIN=/usr/local/sbin/kamailio

############### Compose ##################
# Compose stop
docker-compose --verbose -p ${PROJECT} stop

# Compose start
docker-compose --verbose -p ${PROJECT} up -d

# Wait for kamailio to be running...
until docker top ${PROJECT}_kamailio_async_1 | grep ${KAMAILIO_BIN} ; do
	>&2 echo "kamailio not running yet. Waiting..."
	sleep 2
done

>&2 echo "kamailio running! Launching the tests..."

# Launch tests
docker exec -t ${PROJECT}_sipp_1 env TERM=xterm sh ./run_sipp.sh

>&2 echo "Done with the tests."
