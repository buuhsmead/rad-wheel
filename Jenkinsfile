
pipeline {
    agent {
        kubernetes {
            cloud 'azure-ocp-sandbox'
            namespace 'azure-jenkins'
            serviceAccount 'jenkins'
            yamlFile 'jenkins-pod.yml'
            defaultContainer 'jnlp'
        }
    }

environment {
    HELM_RELEASE_NAME="rad-wheel"
}
    stages {
        stage(' Main ') {
            steps {
		        sh 'date --iso-8601=seconds'
                sh 'hostname'
                sh 'env'
            }
        }

        stage(' Maven package ') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage(' Maven test ') {
            steps {
                sh 'mvn -B test -DskipTests=false'
            }
        }

        stage('helm program itself install') {
            steps {
                sh '''
                curl -o ${JENKINS_AGENT_WORKDIR}/helm.tar.gz  https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
                # checksum: 07c100849925623dc1913209cd1a30f0a9b80a5b4d6ff2153c609d11b043e262
                tar -zxvf ${JENKINS_AGENT_WORKDIR}/helm.tar.gz
                chmod +x ${WORKSPACE}/linux-amd64/helm
                ${WORKSPACE}/linux-amd64/helm help
                '''
            }
        }

	    stage ('Create the Helm Package') {
		    steps {
			    sh '${WORKSPACE}/linux-amd64/helm package helm -d ${JENKINS_AGENT_WORKDIR}'
		    }
	    }

	    stage ('Deploy the App') {
	        steps {
	            withCredentials([string(credentialsId: 'token-jenkins-sa', variable: 'BEARER')]) {
	                sh '''
	                    ${WORKSPACE}/linux-amd64/helm upgrade --install ${HELM_RELEASE_NAME} helm --kube-apiserver https://${API_OPENSHIFT}:6443 --kube-token ${BEARER} --namespace ${DEPLOY_OPENSHIFT_NS}
	                '''
	            }
	        }
	    }

       stage ('image signing') {
	        steps {
	            sh 'echo "Image singing is todo, see https://github.com/redhat-cop/image-scanning-signing-service."'
	        }
	    }

    stage ('Push Helm package JFrog') {
      steps {
        withCredentials([usernamePassword(credentialsId: "Artifactory", usernameVariable: "DEST_USER", passwordVariable: "DEST_PWD")]) {
          sh '''
            curl -v -X PUT --user $DEST_USER:$DEST_PWD --data-binary @"${WORKSPACE}/${HELM_PACKAGE}-${HELM_TAG}.tgz" https://${JFROG_HOST}/${JFROG_REPO}/${HELM_PACKAGE}-${HELM_TAG}.tgz
          '''
        }
      }
    }


}


