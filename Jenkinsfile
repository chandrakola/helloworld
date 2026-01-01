pipeline {
    agent any

    stages {
        stage('Build & Test Services') {
            parallel {
                stage('Django') {
                    steps {
                        script {
                            buildService('django')
                        }
                    }
                }
                stage('SpringBoot') {
                    steps {
                        script {
                            buildService('springboot')
                        }
                    }
                }
                stage('Rails') {
                    steps {
                        script {
                            buildService('rails')
                        }
                    }
                }
                stage('Node') {
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
