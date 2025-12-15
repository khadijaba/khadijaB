pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64/"
        PATH = "${JAVA_HOME}/bin:/opt/apache-maven-3.6.3/bin:${env.PATH}"
    }

    stages {
        // ===== CI =====
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
                    sh "mvn sonar:sonar -Dsonar.projectKey=TP_Project"
                }
            }
        }

       stage('Build JAR') {
    steps {
        sh "mvn package -Dmaven.test.skip=true"
    }
}


        // ===== CD =====
        stage('Build Docker Image') {
            steps {
                // Tag avec le numéro de build Jenkins
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
                sh "kubectl set image deployment/tp-deployment tp-app=khadijaba/tp-app:${env.BUILD_NUMBER}"
                // Applique le service si nécessaire
                sh "kubectl apply -f service.yaml"
            }
        }

        stage('Test Deployment') {
            steps {
                script {
                    // Récupère l'URL exposée par Minikube et teste l'application
                    def url = sh(script: "minikube service tp-service --url", returnStdout: true).trim()
                    sh "curl -v $url"
                }
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
