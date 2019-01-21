#!/bin/sh
sudo iptables -F


myExtIP=$(curl -s http://www.opentlc.com/getip)
myGUID=$(hostname|cut -f2 -d-|cut -f1 -d.)

echo IP: $myExtIP
echo GUID: $myGUID


if [[ $myGUID == 'repl' ]]
   then
	DOMAIN=$myExtIP.xip.io
	HOST=$DOMAIN
	SUFFIX=apps.$DOMAIN
        OPENSHIFT_MASTER_URL="https://$myExtIP:8443"
        OPENSHIFT_COOLSTORE_DEV_URL="http://www-coolstore-dev.$SUFFIX"
        OPENSHIFT_COOLSTORE_PROD_URL="http://www-coolstore-prod.$SUFFIX"
else

	DOMAIN=$myGUID.generic.opentlc.com
	HOST=fuseignite-$DOMAIN
	SUFFIX=apps-$DOMAIN
        OPENSHIFT_MASTER_URL="https://infranode-$myGUID.generic.opentlc.com:8443"
        OPENSHIFT_COOLSTORE_DEV_URL="http://www-coolstore-dev.$SUFFIX"
        OPENSHIFT_COOLSTORE_PROD_URL="http://www-coolstore-prod.$SUFFIX"
fi
echo DOMAIN: $DOMAIN
echo HOST: $HOST
echo SUFFIX: $SUFFIX
echo OPENSHIFT_MASTER_URL: $OPENSHIFT_MASTER_URL
echo OPENSHIFT_COOLSTORE_DEV_URL: $OPENSHIFT_COOLSTORE_DEV_URL
echo OPENSHIFT_COOLSTORE_PROD_URL: $OPENSHIFT_COOLSTORE_PROD_URL

WORKSHOPPER_OPENSHIFT_PROJECT="workshopper"
echo WORKSHOPPER_OPENSHIFT_PROJECT: $WORKSHOPPER_OPENSHIFT_PROJECT

OPENSHIFT_USERNAME="developer"

OPENSHIFT_PASSWORD="developer"

OC_BINARY="/usr/bin/oc"
profile=rehost

echo y | /home/jboss/oc-cluster-wrapper/oc-cluster destroy $profile
rm -rf /root/.oc
/home/jboss/oc-cluster-wrapper/oc-cluster up $profile --public-hostname=$HOST --routing-suffix=$SUFFIX

sleep 60s

echo "oc login.........."
echo y | oc login https://localhost:8443 --username=admin --password=admin --insecure-skip-tls-verify
#echo y | oc login -u system:admin --insecure-skip-tls-verify
oc delete project myproject

chcat -d /root/.oc/profiles/$profile/volumes/vol{01..10}

# Add admin privileges for admin and developer
oc adm policy add-role-to-user system:image-puller system:anonymous
oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm policy add-cluster-role-to-user sudoer developer

# Import jenkins images and re-tag for 3.7
oc import-image jenkins:v3.7 --from='registry.access.redhat.com/openshift3/jenkins-2-rhel7:v3.7' --confirm -n openshift
oc export template jenkins-persistent -n openshift -o json | sed 's/jenkins:latest/jenkins:v3.7/g' | oc replace -f - -n openshift
oc export template jenkins-ephemeral -n openshift -o json | sed 's/jenkins:latest/jenkins:v3.7/g' | oc replace -f - -n openshift

# import Monolith templates and JBoss Imagestreams
oc create -n openshift -f https://raw.githubusercontent.com/bmachado/monolith2microservices/master/monolith/src/main/openshift/template-binary.json
oc create -n openshift -f https://raw.githubusercontent.com/bmachado/monolith2microservices/master/monolith/src/main/openshift/template-prod.json
#oc create -n openshift -f https://raw.githubusercontent.com/RedHat-Middleware-Workshops/modernize-apps-labs/master/monolith/src/main/openshift/template-binary.json
#oc create -n openshift -f https://raw.githubusercontent.com/RedHat-Middleware-Workshops/modernize-apps-labs/master/monolith/src/main/openshift/template-prod.json

# Disable namespace ownership for router
#oc env dc/router ROUTER_DISABLE_NAMESPACE_OWNERSHIP_CHECK=true -n default

echo "Importing images"
oc import-image registry.access.redhat.com/jboss-eap-7/eap71-openshift  --all --confirm --as=system:admin -n openshift 
for is in {"registry.access.redhat.com/rhscl/postgresql-94-rhel7","registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift"}
do 
  oc import-image $is --all --confirm --as=system:admin 
done

### Workshopper
oc new-project "${WORKSHOPPER_OPENSHIFT_PROJECT}"
oc new-app quay.io/osevg/workshopper:0.3 --name=testdrive -e WORKSHOPS_URLS="https://raw.githubusercontent.com/bmachado/amm-rehost-workshopper/master/_workshops/rehost.yml" -e OPENSHIFT_MASTER_URL="$OPENSHIFT_MASTER_URL" -e OPENSHIFT_COOLSTORE_DEV_URL="$OPENSHIFT_COOLSTORE_DEV_URL" OPENSHIFT_COOLSTORE_PROD_URL="$OPENSHIFT_COOLSTORE_PROD_URL"
oc expose svc/testdrive
