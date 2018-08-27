#!/bin/bash
sudo iptables -F

myExtIP=$(curl -s http://www.opentlc.com/getip)
echo IP: $myExtIP

DOMAIN=$myExtIP.xip.io
echo DOMAIN: $DOMAIN

HOST=$DOMAIN
echo HOST: $HOST

SUFFIX=apps.$DOMAIN
echo SUFFIX: $SUFFIX

OPENSHIFT_MASTER_URL="https://$myExtIP:8443"
echo OPENSHIFT_MASTER_URL: $OPENSHIFT_MASTER_URL

OPENSHIFT_COOLSTORE_DEV_URL="http://www-coolstore-dev.$DOMAIN"
echo OPENSHIFT_COOLSTORE_DEV_URL: $OPENSHIFT_COOLSTORE_DEV_URL

OPENSHIFT_COOLSTORE_PROD_URL="http://www-coolstore-prod.$DOMAIN"
echo OPENSHIFT_COOLSTORE_PROD_URL: $OPENSHIFT_COOLSTORE_PROD_URL

WORKSHOPPER_OPENSHIFT_PROJECT="workshopper"
echo WORKSHOPPER_OPENSHIFT_PROJECT: $WORKSHOPPER_OPENSHIFT_PROJECT

OC_BINARY="oc"

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
  ${OC_BINARY} new-project "${WORKSHOPPER_OPENSHIFT_PROJECT}" > /dev/null
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

createNewProject
deployWorkshopper