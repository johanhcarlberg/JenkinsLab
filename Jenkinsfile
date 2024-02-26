pipeline {
    agent any
    environment {
        GIT_URL = 'https://github.com/johanhcarlberg/JenkinsLab'
    }
    stages {
        stage("Checkout") {
            steps {
                git branch: "${params.Branch}", url: "${GIT_URL}"
            }
        }
        stage("Build") {
            steps {
                dir("TrailRunner") {
                    sh("mvn clean compile")
                }
            }
        }
        stage("Test") {
            steps {
                dir("TrailRunner") {
                    sh("mvn test")
                }
            }
            post {
                always {
                    dir("TrailRunner") {
                        junit 'target/surefire-reports/*.xml'
                    }
                }
                success {
                    dir("TrailRunner") {
                        jacoco {
                            execPattern: '**/target/*.exec',
                            classPattern: '**/target/classes/se/iths',
                            sourcePattern: '**/src/main/java/se/iths'
                        }
                    }
                }
            }
        }
    }
}