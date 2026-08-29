pipeline {
    agent any

    environment {
        IMAGE_NAME = "adouke/velos-api"
        IMAGE_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Tester') {
            steps {
                sh 'docker build --target test -t velos-api:test .'
            }
        }
        stage('Construire') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Publier') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Deployer') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-devops', variable: 'KUBECONFIG')]) {
                    sh "kubectl set image deployment/velos-api api=${IMAGE_NAME}:${IMAGE_TAG} --kubeconfig=\$KUBECONFIG"
                    sh "kubectl rollout status deployment/velos-api --kubeconfig=\$KUBECONFIG --timeout=90s"
                }
            }
        }
    }
}