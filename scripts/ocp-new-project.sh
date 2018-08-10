#!/bin/sh
oc new-project workshopper
oc new-app quay.io/osevg/workshopper --name=testdrive -e WORKSHOPS_URLS="https://raw.githubusercontent.com/bmachado/amm-rehost-workshopper/master/_workshops/rehost.yml" -e JAVA_APP=false
oc expose svc/testdrive