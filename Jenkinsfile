
pipeline {
    agent {
        kubernetes {
            cloud 'azure-ocp-sandbox'
            namespace 'azure-jenkins'
            // serviceAccount ''
            yamlFile 'jenkins-pod.yml'
            defaultContainer 'jnlp'
        }
    }
    stages {
        stage('Main') {
            steps {
                sh 'hostname'
            }
        }
        
        stage('Maven package') {
            steps {
                sh 'mvn clean package'
            }
        }
  
        stage('Maven test ') {
            steps {
                sh 'mvn test'
            }
        }        
        
        stage('helm install') {
            steps {
                sh '''
                curl -o ${JENKINS_AGENT_WORKDIR}/helm.tar.gz  https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
                # checksum: 07c100849925623dc1913209cd1a30f0a9b80a5b4d6ff2153c609d11b043e262
                tar -zxvf ${JENKINS_AGENT_WORKDIR}/helm.tar.gz
                #mv linux-amd64/helm /usr/local/bin/helm
                chmod +x /home/jenkins/agent/workspace/rad-wheel/linux-amd64/helm
                /home/jenkins/agent/workspace/rad-wheel/linux-amd64/helm help
                '''
            }
        }
        
        stage(' helm repos') {
            steps {
                sh '/home/jenkins/agent/workspace/rad-wheel/linux-amd64/helm install .'
            }
        }
        
        
        
        stage("Deploy to Dev") {
            steps {
                script{
                    sh "# helm upgrade --install my-guestbook shailendra/guestbook --values dev/values.yaml -n dev --wait"
                }
            }
        }
        
        
    }
}


