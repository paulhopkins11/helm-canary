#!/bin/bash

#************************************************************
# This script adds a 1 pod canary deployment of BLUE servers
#************************************************************

# TODO - Populate this value from the *actual* replica count
REPLICA_COUNT=4
# TODO - Populate this value from the *actual* color of release
RELEASE_COLOR="#FF0000"

CANARY_COLOR="#0000FF"

helm upgrade --install tweet HttpCanary-0.1.0.tgz \
	--set deployment[0].track=release \
	--set deployment[0].color=$RELEASE_COLOR \
	--set deployment[0].replicas=$REPLICA_COUNT \
	--set deployment[1].track=canary \
	--set deployment[1].color=$CANARY_COLOR \
	--set deployment[1].replicas=1 \
	--debug
