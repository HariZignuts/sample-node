// Defines the entire CI/CD process
pipeline {
    // 1. Agent Configuration
    agent any

    // 2. Environment Variables & Centralized Configuration
    environment {
        // Load Docker Hub credentials securely
        DOCKER_CREDS = credentials('dockerhub-creds')
        
        // --- CONFIGURE YOUR PROJECT HERE ---
        // Your Docker Hub username (automatically taken from credentials)
        DOCKERHUB_USERNAME = DOCKER_CREDS_USR
        // The name of your application (e.g., 'sample-node', 'my-api')
        APP_NAME           = "sample-node" // <-- Change this
        
        // The full image name is now constructed automatically
        IMAGE_NAME         = "${DOCKERHUB_USERNAME}/${APP_NAME}"
    }

    // 3. Pipeline Stages
    stages {
        
        // -------- STAGE 1: Build Docker Image (Runs for ALL branches) --------
        stage('Build Image') {
            // No 'when' block, so this stage runs for every branch.
            steps {
                script {
                    // Sanitize branch name for Docker tag (replaces '/' with '-')
                    def sanitizedBranchName = env.BRANCH_NAME.replaceAll('/', '-')
                    echo "Building image for branch '${env.BRANCH_NAME}' with tag '${sanitizedBranchName}'"
                    // Tag the image with the sanitized branch name (e.g., my-app:main, my-app:feature-new-login)
                    sh "docker build -t ${IMAGE_NAME}:${sanitizedBranchName} ."
                }
            }
        }
    }
}