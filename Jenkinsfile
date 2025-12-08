pipeline {
    agent any

    tools {
        maven 'Maven-3.6.3'   // correspond au nom configuré dans Jenkins
        jdk 'JAVA17'          // correspond au nom configuré dans Jenkins
    }

   environment {
    SONARQUBE_TOKEN = credentials('sonar-token')
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
            environment {
                scannerHome = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('My-SonarQube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=TP_Project \
                        -Dsonar.login=$SONARQUBE_TOKEN
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
            echo "Pipeline CI terminée avec succès !"
        }
        failure {
            echo "Erreur dans la pipeline."
        }
    }
}
