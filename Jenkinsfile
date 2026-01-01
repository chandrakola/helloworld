pipeline {
    agent any

    parameters {
        booleanParam(name: 'FORCE_BUILD_ALL', defaultValue: false, description: 'Check this to build all services regardless of recent changes')
    }

    stages {
        stage('Build & Test Services') {
            parallel {
                stage('Django') {
                    when {
                        expression { return shouldBuild('django') }
                    }
                    steps {
                        script {
                            buildService('django')
                        }
                    }
                }
                stage('SpringBoot') {
                    when {
                        expression { return shouldBuild('springboot') }
                    }
                    steps {
                        script {
                            buildService('springboot')
                        }
                    }
                }
                stage('Rails') {
                    when {
                        expression { return shouldBuild('rails') }
                    }
                    steps {
                        script {
                            buildService('rails')
                        }
                    }
                }
                stage('Node') {
                    when {
                        expression { return shouldBuild('node') }
                    }
                    steps {
                        script {
                            buildService('node')
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "docker compose up -d"
                echo "🚀 Services deployed/updated successfully!"
            }
        }
    }
}

// Logic to determine if a service should be built
def shouldBuild(String serviceName) {
    // 1. Build if it's the very first run
    // 2. Build if user manually checked the FORCE_BUILD_ALL box
    if (env.BUILD_NUMBER == '1' || params.FORCE_BUILD_ALL) {
        return true
    }
    
    // 3. Build if the app folder OR any root config files changed in the last commit
    try {
        def rootConfigs = "Jenkinsfile|docker-compose\\.yml|\\.env|\\.gitignore"
        def script = "git diff --name-only HEAD~1 HEAD | grep -E '^apps/${serviceName}/|${rootConfigs}'"
        def changed = sh(returnStatus: true, script: script) == 0
        return changed
    } catch (Exception e) {
        return true // Fallback to building if git check fails
    }
}

def buildService(String serviceName) {
    dir("apps/${serviceName}") {
        // Read codename from VERSION file
        def codename = sh(returnStdout: true, script: "cat VERSION | grep CODENAME | cut -d= -f2").trim()
        def dateTag = sh(returnStdout: true, script: 'date +%Y%m%d').trim()
        def version = "${codename}-${dateTag}-build${env.BUILD_NUMBER}"
        
        echo "Building ${serviceName} version ${version}..."
        
        // Build stage now includes tests (inside Dockerfile)
        sh "docker build -t helloworld-${serviceName}:${version} ."
        sh "docker tag helloworld-${serviceName}:${version} helloworld-${serviceName}:${codename}"
        sh "docker tag helloworld-${serviceName}:${version} helloworld-${serviceName}:latest"
        
        echo "✅ Built ${serviceName} version: ${version}"
    }
}
