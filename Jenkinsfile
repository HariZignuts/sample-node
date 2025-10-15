// Defines the entire CI/CD process
pipeline {
    // 1. Agent Configuration
    agent any

    // 2. Environment Variables & Centralized Configuration
    environment {
        // Load Docker Hub credentials securely
        DOCKER_CREDS = credentials('dockerhub-creds')
        
        // --- CONFIGURE YOUR PROJECT HERE ---
        DOCKERHUB_USERNAME = "malamhari"
        APP_NAME           = "sample-node"
        
        // The full image name is now constructed automatically
        IMAGE_NAME         = "${DOCKERHUB_USERNAME}/${APP_NAME}"
    }

    // 3. Pipeline Stages
    stages {

        // -------- ✅ NEW STAGE: Checkout Code (Runs for ALL branches) --------
        stage('Checkout') {
            steps {
                checkout scm // Checks out the source code from the repository
            }
        }
        
        stage('Build and Push Image') {
            // Only run for main or dev branches
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps {
                script {
                    def sanitizedBranchName = env.BRANCH_NAME.replaceAll('/', '-')
                    echo "Building and pushing image for branch '${env.BRANCH_NAME}'"
                    
                    // The withRegistry block securely logs you in
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        // Use --push to build and send to Docker Hub in one step
                        sh "docker build --push -t ${IMAGE_NAME}:${sanitizedBranchName} ."
                    }
                }
            }
        }
        // -------- ✅ NEW STAGE: Run Docker Container (Runs for ALL branches) --------
        stage('Run Container') {
            steps {
                script {
                    def sanitizedBranchName = env.BRANCH_NAME.replaceAll('/', '-')
                    def containerName = "${APP_NAME}-${sanitizedBranchName}"
                    def imageNameWithTag = "${IMAGE_NAME}:${sanitizedBranchName}"

                    echo "Deploying latest version of ${imageNameWithTag}"

                    // 1. Pull the most recent version of the image from Docker Hub
                    sh "docker pull ${imageNameWithTag}"

                    // 2. Stop and remove the old container if it exists
                    sh "docker rm -f ${containerName} || true"

                    // 3. Start a new container using the freshly pulled image
                    sh "docker run -d -p 3000:3000 --name ${containerName} ${imageNameWithTag}"
                }
            }
        }
    }
}