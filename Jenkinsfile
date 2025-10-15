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
                // This command pulls the source code from your GitHub repository
                // into the Jenkins workspace, making it available for the next stage.
                checkout scm
            }
        }
        
        // -------- STAGE 2: Build Docker Image (Runs for ALL branches) --------
        stage('Build Image') {
            steps {
                script {
                    def sanitizedBranchName = env.BRANCH_NAME.replaceAll('/', '-')
                    echo "Building image for branch '${env.BRANCH_NAME}' with tag '${sanitizedBranchName}'"
                    // Now this command can find your Dockerfile and source code
                    sh "docker build -t ${IMAGE_NAME}:${sanitizedBranchName} ."
                }
            }
        }
    }
}