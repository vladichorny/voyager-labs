def docker_service = "docker-service:1.0.0"
def docker_service_file_name = docker_service.replace(':', '_')
def publish_content = "output"
cygwin_path = "C:\\cygwin64"

pipeline {
    agent { label 'master' }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()
        timestamps()
        timeout(time: 60, unit: 'MINUTES')
    }


    stages {
        stage("Checkout"){
            steps{
                cleanWs()
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                dir("docker-files/docker-service") {
                    runCommand script: "${WORKSPACE}/docker_build.sh"
                }
            }
        }

        stage('Deployment') {
            steps {
                runCommand script: "${WORKSPACE}/deployment.sh"
            }
        }
    }
}

def runCommand(Map config = [:]) {
    def script = config.script

    if (isUnix()) {
        sh script: "sh $script"
    } else {
        bat script: """
            ${cygwin_path}\\bin\\bash --login "${script}"
        """
    }
}
