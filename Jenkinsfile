pipeline {
    agent any
    environment {
        GIT_URL = 'https://github.com/johanhcarlberg/JenkinsLab'
    }
    stages {
        stage("Checkout") {
            steps {
                git branch: ${params.Branch}, url: "${GIT_URL}"
            }
        }
        stage("Test") {
            steps {
                echo "Testing"
                echo "Branch choice: ${params.Branch}"
            }
        }
    }
}