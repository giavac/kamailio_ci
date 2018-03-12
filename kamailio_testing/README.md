# Testing Kamailio in various conditions with Docker

The purpose of this project is to provide an example on how specific configurations of Kamailio can be tested by using a combination of tools like `sipp` and `Docker`.

In particular, we show a way to test the `http_async_client` module, which by its nature requires the interaction with an HTTP server. In our case we abstracted this with a container running `nginx`, but of course a good approach for others could be to spawn a container with their specific web application.

In order to generate the requests from `http_async_client` we are using `sipp` to generate SIP requests.
The target of the HTTP requests can be hardcoded in the Kamailio routing script, but it can also be passed via custom SIP headers, as we do. In this way several scenarios can be triggered without the need to modify the routing script.


# Testing http_async_client Kamailio module

1. Build base images for `sipp`, `nginx` and all `kamailio_async_DISTRIBUTION` (see related READMEs)
1. git clone kamailio source code in KAMAILIO_SRC folder
1. Run `./prepare_built_kamailio.sh [TEST_USER] [TEST_DISTRIBUTION] [KAMAILIO_SRC] [GIT_REF]`. By changing the parameters, you can create various images with Kamailio already built and ready to run. `GIT_REF` can be a branch name (Anything you would use in a `git checkout GIT_REF` command).
1. Choose which `TEST_IMAGE` image to use, with Kamailio already built and installed. You can list the related images with something like `docker images | grep kamailio_async`
1. `./kamailio_async_DISTRIBUTION/scripts/kamailio.cfg` contains the configuration under test
1. Run `./launch_tests.sh TEST_IMAGE [TEST_USER] [TEST_DISTRIBUTION]` to launch the test against the chosen combination of git hash and distribution.
1. You can also change the Kamailio routing script and re-launch the tests

## Build base images for kamailio

(see also specific README files in subfolders)

1. cd kamailio_async_DISTRIBUTION/
1. `docker build -t USER/kamailio_async:DISTRIBUTION -f Dockerfile.DISTRIBUTION .`

e.g.: `docker build -t gvacca/kamailio_async:centos7 -f Dockerfile.centos7 .`

### Check images available

1. `docker images | grep kamailio`

e.g.:

```
$ docker images |grep kamailio
gvacca/kamailio_async   centos7             f3a5bcc0a2d9        4 days ago          393.8 MB
gvacca/kamailio_async   src_ubuntu14        4c9cae1b1066        4 months ago        492.6 MB
gvacca/kamailio_async   ubuntu14            38e28100f1cc        4 months ago        299.9 MB
```

## Build base images for nginx

1. `cd nginx_ssl`
1. `docker build -t USER/nginx_ssl .`

## Build base images for sipp

1. `cd sipp`
1. `docker build -t USER/sipp .`

## Starting up the test bed

1. `docker-compose --verbose up -d`

(`--verbose` is obviously optional)

Compose will launch all the containers. For Kamailio, it will launch a container on the base image and at the same time start the build (via `build_run.sh` script).
The source code is accessed from outside the container, via a volume.

After the build, the shell script starts Kamailio.

## Networking

Compose creates a "docker network", called by default "PROJECT_default". It uses a private addressing, as Docker networks do.

Compose provides a naming system that allows addressing the containers with their names instead of IP addresses.

So e.g. the nginx container is reachable at the name "PROJECT_nginx_1".

In this dir tree PROJECT is `kamailiotesting`, as Docker assigns it by default depending on the enclosing folder name.

## Launch the tests

The sipp scenarios are made available through a volume, so that the image doesn't need to be rebuilt if the scenarios change. In this way you can experiment and add/remove scenarios more easily.

From inside the container, execute `./run_sipp.sh`.

e.g.:

```
docker exec -ti kamailiotesting_sipp_1 /bin/bash
root@29d589f5db0c:~/sipp# ./run_sipp.sh

------------------------------ Scenario Screen -------- [1-9]: Change Screen --
  Call-rate(length)   Port   Total-time  Total-calls  Remote-host
   1.0(0 ms)/1.000s   5060       1.17 s            1  172.18.0.3:5060(UDP)

  Call limit reached (-m 1), 0.000 s period  0 ms scheduler resolution
  0 calls (limit 3)                      Peak was 1 calls, after 1 s
  0 Running, 4 Paused, 0 Woken up
  0 dead call msg (discarded)            0 out-of-call msg (discarded)        
  1 open sockets                        

                                 Messages  Retrans   Timeout   Unexpected-Msg
     MESSAGE ---------->         1         0         0                  
         200 <----------         1         0         0         0        
------------------------------ Test Terminated --------------------------------
```

## nginx, HTML and certificates

Both the "website" (static code provided by nginx) and the certificates used for TLS connections are available through volumes.

The website can be changed without rebuilding the image (or restarting nginx).

There are some self-signed certificates available. In particular for cases where certificate validation is under test, you need to provide proper certificates.
