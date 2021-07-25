
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
                    sh script: """
                        eval $(minikube docker-env)
                        docker rmi --force docker-service:1.0.0 || true                                    
                        docker build --rm --tag docker-service:1.0.0 .
                        docker scan  docker-service:1.0.0
                        eval $(minikube docker-env --unset)
                    """
                }
            }
        }

        stage('Deployment') {
            steps {
                sh script: """
                    ansible-playbook ./ansible-playbook/install.yml
                    service=$(minikube service --url web-service)
                """
            }
        }

        post {
            always {
                println "This build and deployment took: ${currentBuild.durationString}"
            }
        }
    }
}

