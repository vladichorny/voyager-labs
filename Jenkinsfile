
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
                    script {
                        if (isUnix()) {
                            sh script: """
                                docker image inspect --format '{{index .RepoTags}}' "docker-service:1.0.0" 2> /dev/null | grep -q "docker-service:1.0.0" && \
                                    docker rmi --force docker-service:1.0.0 || true
                                docker build --rm --tag docker-service:1.0.0 .
                            """
                        } else {
                            bat script: """
                                docker image inspect --format '{{index .RepoTags}}' "docker-service:1.0.0" 2> /dev/null | grep -q "docker-service:1.0.0" && \
                                    docker rmi --force docker-service:1.0.0 || true
                                docker build --rm --tag docker-service:1.0.0 .
                            """
                        }
                    }
                }
            }
        }

        stage('Deployment') {
            steps {
                runCygwin script: "${WORKSPACE}/deployment.sh"
            }
        }
    }
}

def runCygwin(Map config = [:]) {
    def script = config.script

    if (isUnix()) {
        sh script: "sh ${script}"
    } else {
        def script_linux_format = script.replace("\\", "/")
        bat script: """
            ${cygwin_path}\\bin\\bash --login -c "dos2unix ${script_linux_format}"
            ${cygwin_path}\\bin\\bash --login "${script_linux_format}"
        """
    }
}
