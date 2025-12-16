pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64/"
        PATH = "${JAVA_HOME}/bin:/opt/apache-maven-3.6.3/bin:${env.PATH}"
        DOCKER_IMAGE = "khadijaba/tp-app:${BUILD_NUMBER}" // image Docker taguée avec le numéro du build
        SONAR_TOKEN = credentials('sonar-token') // Ton token SonarQube stocké dans Jenkins
        GIT_CREDENTIALS = 'git-credentials' // Tes credentials Git
    }

    stages {

        stage('Checkout Code') {
            steps {
                git(
                    url: 'https://github.com/khadijaba/khadijaB.git',
                    branch: 'main',
                    credentialsId: "${GIT_CREDENTIALS}"
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

        stage('Run Tests & Code Coverage') {
            steps {
                sh 'mvn test jacoco:report'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My-SonarQube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=TP_Project \
                        -Dsonar.token=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                """
            }
        }

    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            echo "Build and Deployment SUCCESSFUL! "
        }
        failure {
            echo "Build or Deployment FAILED! "
        }
    }
}
