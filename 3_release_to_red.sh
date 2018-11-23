#!/bin/bash

#************************************************************
# This script simply runs a 4 pod deployment of RED servers.
# This should be more complex as described below. If 
# implemented as is it will probably tear down the old pods
# before the new pods are up and running.
#************************************************************

# TODO - Populate this value from the *actual* replica count
REPLICA_COUNT=4
# New release color will be RED
RELEASE_COLOR="#FF0000"

# This will perform rolling updates on the existing release pods
helm upgrade --install tweet HttpCanary-0.1.0.tgz \
	--set deployment[0].track=release \
	--set deployment[0].color=$RELEASE_COLOR \
	--set deployment[0].replicas=$REPLICA_COUNT \
	--debug
