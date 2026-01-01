pipeline {
    agent any

    stages {
        stage('Build & Test Services') {
            parallel {
                stage('Django') {
                    when {
                        expression { return env.BUILD_NUMBER == '1' || anyChangesIn('apps/django') }
                    }
                    steps {
                        script {
                            buildService('django')
                        }
                    }
                }
                stage('SpringBoot') {
                    when {
                        expression { return env.BUILD_NUMBER == '1' || anyChangesIn('apps/springboot') }
                    }
                    steps {
                        script {
                            buildService('springboot')
                        }
                    }
                }
                stage('Rails') {
                    when {
                        expression { return env.BUILD_NUMBER == '1' || anyChangesIn('apps/rails') }
                    }
                    steps {
                        script {
                            buildService('rails')
                        }
                    }
                }
                stage('Node') {
                    when {
                        expression { return env.BUILD_NUMBER == '1' || anyChangesIn('apps/node') }
                    }
                    steps {
                        script {
                            buildService('node')
                        }
                    }
                }
            }
        }
    }
}

// Helper to detect changes in a specific directory
def anyChangesIn(String path) {
    // On first build, this doesn't matter as expression handles it
    // On subsequent builds, check the diff between this commit and the previous one
    try {
        def changed = sh(returnStatus: true, script: "git diff --name-only HEAD~1 HEAD | grep '^${path}/'") == 0
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
