
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
                        # eval $(minikube docker-env)
                        docker rmi --force docker-service:1.0.0 || true                                    
                        docker build --rm --tag docker-service:1.0.0 .
                        docker scan  docker-service:1.0.0
                        # eval $(minikube docker-env --unset)
                    """
                }
            }
        }

        stage('Deployment') {
            steps {
                sh script: """
                    # eval $(minikube docker-env)
                    ansible-playbook ./ansible-playbook/install.yml
                    # eval $(minikube docker-env --unset)
                    # service=$(minikube service --url web-service)
                """
            }
        }

        post {
            always {
                println "This build and deployment took: ${currentBuild.durationString}"
                println "Please run: 'minikube service --url web-service' to get web page url and open url in your browser"
            }
        }
    }
}

