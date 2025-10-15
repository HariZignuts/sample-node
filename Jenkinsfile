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
                echo "Restarting container '${containerName}' for branch '${env.BRANCH_NAME}' with tag '${sanitizedBranchName}'"

                // Stop and remove if already running/existing (ignore errors if not found)
                sh "docker rm -f ${containerName} || true"

                // Start fresh container
                sh "docker run -d -p 3000:3000 --name ${containerName} ${IMAGE_NAME}:${sanitizedBranchName}"
            }
            }
        }
    }
}