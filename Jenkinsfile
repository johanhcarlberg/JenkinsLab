pipeline {
    agent any
    environment {
        GIT_URL = 'https://github.com/johanhcarlberg/JenkinsLab'
    }
    parameters {
        choice(name: 'Branch', choices: ["main","b1"], description: "Select branch to checkout")
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'main', name: 'BRANCH', type: 'PT_BRANCH'
    }
    stages {
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
                    sh("mvn spotbugs:spotbugs")
                    script {
                        def spotBugs = scanForIssues tool: spotBugs(pattern: '**/target/spotbugsXml.xml', useRankAsPriority: true)
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