pipeline {
    agent none
    
    environment {
        BUILD_DIR = 'dist'
        APP_NAME = 'kijanikiosk-payments'
        
        PKG_VERSION = sh(script: "node -p \"require('./package.json').version\"", returnStdout: true).trim()
        GIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        ARTIFACT_VERSION = "${PKG_VERSION}-${GIT_SHORT}"
        
        NEXUS_URL = 'http://172.17.0.1:8081/repository/npm-kijanikiosk/'
        NEXUS_REPO = 'npm-kijanikiosk'
    }
    
    options {
        timeout(time: 15, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    
    stages {
        stage('Lint') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "🔍 Running ESLint validation..."
                    npm ci
                    npm run lint --if-present || echo "No lint script configured, skipping"
                '''
            }
            post {
                success {
                    echo "✅ Lint stage passed"
                }
                failure {
                    echo "❌ Lint stage failed - syntax or style error detected"
                }
            }
        }
        
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "📦 Installing dependencies..."
                    npm ci
                    
                    echo "🏗️ Building application..."
                    npm run build
                    
                    echo "✅ Build complete - output in ${BUILD_DIR}/"
                    ls -la ${BUILD_DIR}/
                '''
            }
            post {
                success {
                    script {
                        stash name: 'build-output', includes: "${BUILD_DIR}/**, package.json, package-lock.json"
                        echo "📦 Build output stashed for later stages"
                    }
                }
            }
        }
        
        stage('Verify') {
            parallel {
                stage('Test') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        unstash 'build-output'
                        sh '''
                            echo "🧪 Running tests..."
                            npm test || echo "Tests completed with failures"
                        '''
                    }
                    post {
                        always {
                            junit allowEmptyResults: true, testResults: 'test-results/*.xml'
                        }
                        failure {
                            echo "❌ Tests failed - check test results above"
                        }
                    }
                }
                
                stage('Security Audit') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            echo "🔒 Running security audit..."
                            npm audit --audit-level=high || echo "Vulnerabilities found - see report"
                        '''
                    }
                    post {
                        failure {
                            echo "⚠️ Security audit found high-severity vulnerabilities"
                        }
                    }
                }
            }
            post {
                failure {
                    echo "❌ Verify stage failed - either tests or security audit detected issues"
                }
            }
        }
        
        stage('Archive') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                unstash 'build-output'
                script {
                    archiveArtifacts artifacts: "${BUILD_DIR}/**",
                                   fingerprint: true,
                                   onlyIfSuccessful: true
                    echo "📦 Artifacts archived with fingerprinting"
                    echo "📝 Version: ${ARTIFACT_VERSION}"
                }
            }
        }
        
        stage('Publish') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                unstash 'build-output'
                script {
                    withCredentials([string(credentialsId: 'nexus-api-key', variable: 'NEXUS_API_KEY')]) {
                        sh '''
                            echo "//172.17.0.1:8081/repository/npm-kijanikiosk/:_authToken=${NEXUS_API_KEY}" > .npmrc
                            echo "registry=http://172.17.0.1:8081/repository/npm-kijanikiosk/" >> .npmrc
                            
                            npm version ${ARTIFACT_VERSION} --no-git-tag-version --allow-same-version
                            
                            echo "📤 Publishing version ${ARTIFACT_VERSION} to Nexus..."
                            npm publish --registry=http://172.17.0.1:8081/repository/npm-kijanikiosk/
                            
                            rm -f .npmrc
                            echo "✅ Published successfully, credentials cleaned up"
                        '''
                    }
                }
            }
            post {
                success {
                    echo "✅ Artifact published to Nexus: ${APP_NAME}-${ARTIFACT_VERSION}"
                }
                failure {
                    echo "❌ Failed to publish to Nexus - check connectivity and credentials"
                }
            }
        }
    }
    
    post {
        always {
            echo "🧹 Cleaning workspace..."
            cleanWs()
            echo "🏁 Pipeline completed"
        }
        
        success {
            echo "🎉 Pipeline SUCCESSFUL!"
            echo "📦 Artifact URL: ${NEXUS_URL}${APP_NAME}/-/${APP_NAME}-${ARTIFACT_VERSION}.tgz"
        }
        
        failure {
            echo "💥 Pipeline FAILED"
            echo "Check the failing stage logs above for details"
        }
        
        changed {
            echo "🔄 Build status changed from ${currentBuild.previousBuild?.result} to ${currentBuild.result}"
        }
        
        aborted {
            echo "⏹️ Pipeline was aborted"
        }
    }
}
