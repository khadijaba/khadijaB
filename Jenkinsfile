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
    }

    post {
        success {
            echo "Pipeline CI terminée avec succès ! ✅"
        }
        failure {
            echo "Erreur da
