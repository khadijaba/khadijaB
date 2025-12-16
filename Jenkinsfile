pipeline {
    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonar-token')
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_IMAGE = 'khadijaba/tp-app'
        K8S_NAMESPACE = 'default'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git(
                    url: 'https://github.com/khadijaba/khadijaB.git',
                    branch: 'main',
                    credentialsId: 'git-credentials'
                )
            }
        }

        stage('Clean Project') {
            steps {
                sh 'mvn clean'
            }
        }

        stage('Compile Project') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My-SonarQube') {
                    sh "mvn sonar:sonar -Dsonar.projectKey=TP_Project -Dsonar.login=$SONARQUBE_TOKEN"
                }
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: DOCKER_HUB_CREDENTIALS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker build -t $DOCKER_IMAGE:latest .
                        docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy on Kubernetes') {
            environment {
                KUBECONFIG = '/var/lib/jenkins/jenkins-kubeconfig'
            }
            steps {
                sh '''
                    kubectl get nodes
                    kubectl apply -f k8s/mysql.yaml
                    kubectl apply -f k8s/deployment.yaml
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
