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

# This should really do the following rather than just a hard cut over
# scale canary to 4
# scale release to 0
# label release as to_be_removed
# label canary as release
# remove to_be_removed

helm upgrade --install tweet HttpCanary-0.1.0.tgz \
	--set deployment[0].track=release \
	--set deployment[0].color=$RELEASE_COLOR \
	--set deployment[0].replicas=$REPLICA_COUNT \
	--debug
