#!/bin/bash

#************************************************************
# This script adds an additional single pod canary deployment
#************************************************************

# TODO - Populate this value from the *actual* replica count
REPLICA_COUNT=4
# TODO - Populate this value from the *actual* color of release
RELEASE_COLOR="#0000FF"

CANARY_COLOR="#FF0000"

helm upgrade --install tweet HttpCanary-0.1.0.tgz \
	--set deployment[0].track=release \
	--set deployment[0].color=$RELEASE_COLOR \
	--set deployment[0].replicas=$REPLICA_COUNT \
	--set deployment[1].track=canary \
	--set deployment[1].color=$CANARY_COLOR \
	--set deployment[1].replicas=1 \
	--debug
