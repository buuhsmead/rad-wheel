
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
        
        
        stage('S2I build') {
            steps {
                sh 'mvn clean package'
            }
        }
  
        stage('S2I bake') {
            steps {
                sh 'S2I bake'
            }
        }        
        
        stage('S2I image tag') {
            steps {
                sh 'S2I image tag'
            }
        }
        
        stage('S2I push') {
            steps {
                sh 'S2I push to JFrog'
            }
        }        
        
        stage('helm install') {
            steps {
                sh '''
                curl -O https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
                # checksum: 07c100849925623dc1913209cd1a30f0a9b80a5b4d6ff2153c609d11b043e262
                tar -zxvf helm-v3.6.3-linux-amd64.tar.gz
                mv linux-amd64/helm /usr/local/bin/helm
                # chmod +x /usr/local/bin/helm
                helm help
                '''
            }
        }
        
        stage(' helm repos') {
            steps {
                sh 'echo "ADD HELM REPO"'
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


