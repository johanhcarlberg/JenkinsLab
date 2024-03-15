pipeline {
    agent any
    environment {
        GIT_URL = 'https://github.com/johanhcarlberg/JenkinsLab'
    }
    parameters {
        choice(name: 'Branch', choices: ["main","b1"], description: "Select branch to checkout")
    }
    options {
        skipDefaultCheckout()
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
        stage("Analyze") {
            steps {
                dir("TrailRunner") {
                    script {
                        sh("mvn spotbugs:spotbugs")
                        def spotbugs = sscanForIssues tool: spotBugs(pattern: '**/target/spotBugsXml.xml', useRankAsPriority: true)
                        publishIssues([spotBugs])
                    }
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
                        jacoco(
                            execPattern: '**/target/*.exec',
                            classPattern: '**/target/classes/se/iths',
                            sourcePattern: '**/src/main/java/se/iths'
                        )
                    }
                }
            }
        }
        stage("Run Robot") {
            steps {
                dir("Selenium") {
                    sh script: "robot --nostatusrc --skip expected-fail --outputdir results --variable browser:headlesschrome CarRentalTests.robot", returnStatus: true
                }
            }
            post {
                always {
                    dir("Selenium") {
                        robot outputPath: 'results', passThreshold: 100.0, unstableThreshold: 100.0, onlyCritical: false
                    }
                }
                cleanup {
                    dir("Selenium") {
                        sh "rm -f results/*"
                    }
                }
            }
        }
    }
}