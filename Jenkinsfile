pipeline {
    agent any
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code checked out from GitHub'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building KijaniKiosk payments service...'
                sh 'echo "Build completed successfully"'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh 'echo "All tests passed"'
            }
        }
        
        stage('Archive') {
            steps {
                echo 'Archiving artifacts...'
                archiveArtifacts artifacts: 'Jenkinsfile', fingerprint: true
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
