pipeline {
	environment {
		IMAGE_NAME = "helloworld"
		IMAGE_TAG = "latest"
		STAGING = "victor-staging"
		PRODUCTION = "victor-production"
		DOCKERHUB_LOGIN = "banhcanh"
	}
	agent none
	stages {
		stage('Build image') {
                        agent {
                                docker {
                                                image 'docker:dind'
                                }
                        }
			steps {
				script {
					sh 'docker build -t $DOCKERHUB_LOGIN/$IMAGE_NAME:$IMAGE_TAG .'
				}
			}
		}
		stage('Start Container') {
			agent any
			steps {
				script {
					sh 'docker run -it --name ${IMAGE_NAME} -p 81:80 -d ${DOCKERHUB_LOGIN}/${IMAGE_NAME}:${IMAGE_TAG}'
				}
			}
		}
		stage('Test Container') {
                        agent any
			steps {
				script {
					sh '''
					    sleep 5
						var=$(curl http://172.17.0.1:5000)
						if [ "$var" = 'Hello world!' ]; then exit 0; else exit 1; fi
					'''
				}
			}
		}
		stage('Clean Container') {
                        agent {
                                docker {
                                                image 'docker:dind'
                                }
                        }
			steps {
				script {
					sh 'docker rm -f ${IMAGE_NAME}'
				}
			}
		}
		stage('Push image on dockerhub') {
                        agent {
                                docker {
                                                image 'docker:dind'
                                }
                        }
			environment {
				DOCKERHUB_SECRET = credentials('dockerhub_secret')
			}
			steps {
				script {
					sh '''
					docker login --username ${DOCKERHUB_SECRET_USR} --password ${DOCKERHUB_SECRET_PSW}
					docker push ${DOCKERHUB_LOGIN}/${IMAGE_NAME}:${IMAGE_TAG}
					'''
				}
			}
		}
	}
}
