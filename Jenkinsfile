pipeline {
    environment { 
        imageName = "sec911/flask-kubeapi" 
        registryCredential = 'dockerhub_id'
        dockerImage = ''
    }
    agent any
    stages { 
        stage('Pulling latest code') {
            steps {
                git 'https://github.com/rfmsec/flask-kubeapi.git'
            }
        }
        stage('Building') { 
            steps { 
                script { 
                    dockerImage = docker.build imageName + ":$BUILD_NUMBER" 
                }
            } 
        }
        stage('Deploy the helm charts') {
           steps {   
               script {
                   sh 'helm install flask-kubeapi-test ' + imageName + ":$BUILD_NUMBER"
              }
           }
        }
        stage('Push the build to hub') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi \$(docker image ls | grep -im1 " + imageName + " | awk '{print \$3}') -f"
                sh "helm delete flask-kubeapi-test"
            }
        } 
    }
}