#!/usr/bin/env bash

set -e

JENKINS_PROJECT=azure-jenkins
JENKINS_SA=jenkins

HELM_RELEASE_NAME=maven-template

OCP_API=api.guid.it-speeltuin.eu
OCP_DEPLOY_NS=maven-template

oc new-project ${JENKINS_PROJECT} --display-name "Jenkins remote controller"
oc create serviceaccount ${JENKINS_SA}
# The JENKINS_SA needs to be able to create a POD
oc policy add-role-to-user edit system:serviceaccount: ${JENKINS_PROJECT}:JENKINS_SA -n ${JENKINS_PROJECT}

OCP_API_TOKEN=$(oc serviceaccounts get-token ${JENKINS_SA} -n ${JENKINS_PROJECT})

echo "===== copy this into a secret-text credential in Jenkins ====="
echo ${OCP_API_TOKEN}
echo "===== end ===="

###oc policy add-role-to-user edit system:serviceaccount:${JENKINS_PROJECT}:${JENKINS_PROJECT}


# Setup the NAMESPACE the APP will be deployed in
oc new-project ${OCP_DEPLOY_NS} --display-name "APP from ${HELM_RELEASE_NAME}"

##oc create -f git-source-secret.yaml -n ${OCP_DEPLOY_NS}

# admin rights for JENKINS_SA because of the build-rbac for SA of APP
oc policy add-role-to-user admin system:serviceaccount:${JENKINS_PROJECT}:${JENKINS_SA} -n ${OCP_DEPLOY_NS}


# Deploy the APP into the already prepared NAMESPACE

OCP_API_TOKEN=$(oc serviceaccounts get-token ${JENKINS_SA} -n ${JENKINS_PROJECT})

helm upgrade --install ${HELM_RELEASE_NAME} maven-template --kube-apiserver https://${OCP_API}:6443 --kube-token "${OCP_API_TOKEN}" --namespace ${OCP_DEPLOY_NS}



