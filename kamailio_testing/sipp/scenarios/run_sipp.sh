#!/bin/bash

#sipp -sf hac_HTTP_GET.xml kamailio_async -r 1 -m 1
#sipp -sf hac_HTTPS_GET.xml kamailio_async -r 1 -m 1

#sipp -sf hac_HTTP_POST_body.xml kamailio_async -r 1 -m 1
#sipp -sf hac_HTTPS_POST_body.xml kamailio_async -r 1 -m 1

# Basic authentication - must pass username and password
#sipp -sf hac_HTTP_GET_basicauth_200.xml kamailio_async -r 1 -m 1

# Basic authentication - pass wrond username/password
sipp -sf hac_HTTP_GET_basicauth_401.xml kamailio_async -r 1 -m 1
