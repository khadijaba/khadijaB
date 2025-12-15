pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64/"
        PATH = "${JAVA_HOME}/bin:/opt/apache-maven-3.6.3/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-credentials',
                    url: 'https://github.com/khadijaba/khadijaB.git'
            }
        }

        stage('Clean Project') {
            steps {
                sh "mvn clean"
            }
        }

        stage('Compile Project') {
            steps {
                sh "mvn compile"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My-SonarQube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=TP_Project
                    """
                }
            }
        }

        stage('Build JAR') {
            steps {
                sh "mvn package -DskipTests"
            }
        }

        stage('Build Docker Image') {
            steps {
                // On utilise le numéro de build Jenkins pour taguer l'image
                sh "docker build -t khadijaba/tp-app:${env.BUILD_NUMBER} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push khadijaba/tp-app:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Met à jour le déploiement avec la nouvelle image
                sh "kubectl set image deployment/tp-app tp-app=khadijaba/tp-app:${env.BUILD_NUMBER}"
                sh "kubectl apply -f service.yaml"
            }
        }
    }

    post {
        success {
            echo "Pipeline CI/CD terminée avec succès ! "
        }
        failure {
            echo "Erreur dans la pipeline "
        }
    }
}
