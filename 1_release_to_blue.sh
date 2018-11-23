#!/bin/bash

#************************************************************
# This script starts a 4 pod deployment of BLUE servers
#************************************************************

# TODO - Populate this value from the *actual* replica count
REPLICA_COUNT=4
# Release color will be BLUE
RELEASE_COLOR="#0000FF"

helm upgrade --install tweet HttpCanary-0.1.0.tgz \
	--set deployment[0].track=release \
	--set deployment[0].color=$RELEASE_COLOR \
	--set deployment[0].replicas=$REPLICA_COUNT \
	--debug
