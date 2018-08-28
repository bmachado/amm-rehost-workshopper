#!/bin/bash
sudo iptables -F

myExtIP=$(curl -s http://www.opentlc.com/getip)
echo myExtIP: $myExtIP

myGUID=$(awk -F "[ ]+" '/GUID/{print $NF}' /etc/motd)
echo myGUID: $myGUID

if [[ -z $myGUID ]]
   then
        DOMAIN=$myExtIP.xip.io
        HOST=$DOMAIN
        SUFFIX=$DOMAIN
        OPENSHIFT_MASTER_URL="https://$myExtIP:8443"
        OPENSHIFT_COOLSTORE_DEV_URL="http://www-coolstore-dev.$SUFFIX"
        OPENSHIFT_COOLSTORE_PROD_URL="http://www-coolstore-prod.$SUFFIX"
   else
        DOMAIN=$myGUID.generic.opentlc.com
        HOST=$DOMAIN
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

# check if oc client has an active session
isLoggedIn() {
  echo "Checking if you are currently logged in..."
  ${OC_BINARY} whoami > /dev/null
  OUT=$?
  if [ ${OUT} -eq 1 ]; then
    echo "Log in to your OpenShift cluster: oc login --server=openshiftIP"
    exit 1
  else
    CONTEXT=$(${OC_BINARY} whoami -c)
    echo "Active session found. Your current context is: ${CONTEXT}"
  fi
}

createNewProject() {

  WAIT_FOR_PROJECT_TO_DELETE=true
  WORKSHOPPER_REMOVE_PROJECT=true
  DELETE_OPENSHIFT_PROJECT_MESSAGE=$(echo "Removing namespace ${WORKSHOPPER_OPENSHIFT_PROJECT}")

  if ${OC_BINARY} get project "${WORKSHOPPER_OPENSHIFT_PROJECT}" &> /dev/null; then
    echo "Namespace \"${WORKSHOPPER_OPENSHIFT_PROJECT}\" exists."
    while $WAIT_FOR_PROJECT_TO_DELETE
    do
    { # try
      echo -n $DELETE_OPENSHIFT_PROJECT_MESSAGE
      if $WORKSHOPPER_REMOVE_PROJECT; then
        ${OC_BINARY} delete project "${WORKSHOPPER_OPENSHIFT_PROJECT}" &> /dev/null
        WORKSHOPPER_REMOVE_PROJECT=false
      fi
      DELETE_OPENSHIFT_PROJECT_MESSAGE="`tput setaf 2`.`tput sgr0`"
      if ! ${OC_BINARY} get project "${WORKSHOPPER_OPENSHIFT_PROJECT}" &> /dev/null; then
        WAIT_FOR_PROJECT_TO_DELETE=false
      fi
      echo -n $DELETE_OPENSHIFT_PROJECT_MESSAGE
    }
    done
    echo "`tput setaf 2` Done!`tput sgr0`"
  fi
  echo "Creating namespace \"${WORKSHOPPER_OPENSHIFT_PROJECT}\""
  # sometimes even if the project does not exist creating a new one is impossible as it's apparently exists
  sleep 1
  ${OC_BINARY} new-project "${WORKSHOPPER_OPENSHIFT_PROJECT}"
#  ${OC_BINARY} new-project "${WORKSHOPPER_OPENSHIFT_PROJECT}" > /dev/null
  OUT=$?
  if [ ${OUT} -eq 1 ]; then
    echo "Failed to create namespace ${WORKSHOPPER_OPENSHIFT_PROJECT}. It may exist in someone else's account or namespace deletion has not been fully completed. Try again in a short while or pick a different project name -p=myProject"
    exit ${OUT}
  else
    echo "Namespace \"${WORKSHOPPER_OPENSHIFT_PROJECT}\" successfully created"
  fi
}

deployWorkshopper() {
  oc new-app quay.io/osevg/workshopper:0.3 --name=testdrive -e WORKSHOPS_URLS="https://raw.githubusercontent.com/bmachado/amm-rehost-workshopper/master/_workshops/rehost.yml" -e OPENSHIFT_MASTER_URL="$OPENSHIFT_MASTER_URL" -e OPENSHIFT_COOLSTORE_DEV_URL="$OPENSHIFT_COOLSTORE_DEV_URL" OPENSHIFT_COOLSTORE_PROD_URL="$OPENSHIFT_COOLSTORE_PROD_URL"
  oc expose svc/testdrive
}

isLoggedIn
createNewProject
deployWorkshopper