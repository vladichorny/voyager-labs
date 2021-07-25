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
                    runCommand script: """
                        docker image inspect --format '{{index .RepoTags}}' "${docker_service}" 2> /dev/null | grep -q "${docker_service}" && \
                            docker rmi --force ${docker_service} || true
                        docker build --rm --tag ${docker_service} .
                        # docker save ${docker_service} > ${WORKSPACE}/${publish_content}/${docker_service_file_name}.dockerimage
                        # gzip ${WORKSPACE}/${publish_content}/${docker_service_file_name}.dockerimage
                    """
                }
            }
        }

        stage('Deployment') {
            steps {
                runCommand script: """
                    ansible-playbook ansible-playbook/install.yml
                    service=\$(minikube service --url web-service)
                    echo "\$service"
                    #start www.google.com
                """
            }
        }
    }
}

def runCommand(Map config = [:]) {
    def script = config.script

    if (isUnix()) {
        sh script: script
    } else {
        bat script: """
            ${cygwin_path}\\bin\\bash --login -c "${script}"
        """
    }
}
