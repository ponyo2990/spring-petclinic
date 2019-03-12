pipeline {
    agent any
        tools {
            maven 'maven'
        }
    stages {
        stage('checkout'){
            steps {
            	slackSend (color: '00ff00', message: "Checking out git..for Job: ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER}")
                git branch: 'master',
                url: 'https://github.com/ponyo2990/spring-petclinic'
            }
        }
        stage('Build') {
            steps {
                slackSend (color: '00ff00', message: "On build stage")
                sh 'chmod u+x mvnw'
                sh './mvnw package'
            }
        }
	
	    stage('Test') {
	    steps {
	        slackSend (color: '00ff00', message: "On Test stage")
		    junit '**/target/surefire-reports/TEST-*.xml'
		}
	}

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar'
            }
            steps{
            	  slackSend (color: '00ff00', message: "In SonarQube Analysis now..")
                  withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
                       withSonarQubeEnv('sonarqube'){
                            echo "${env.BUILD_NUMBER}"
                            sh "${scannerHome}/bin/sonar-scanner -X" +
                                " -e -Dsonar.host.url=http://sonarqube:9000" +
                                " -Dsonar.login=${sonarLogin}" +
                                " -Dsonar.projectName=petclinic" + 
                                " -Dsonar.projectVersion=${env.BUILD_NUMBER}" + 
                                " -Dsonar.projectKey=PC" + 
                                " -Dsonar.sources=src/main/" + 
                                " -Dsonar.tests=target/surefire-reports" +
                                " -Dsonar.java.binaries=target/classes" +
                                " -Dsonar.language=java"
                        }
                        //timeout(time: 10, unit: 'MINUTES') {
                          //  waitForQualityGate abortPipeline: true
                        }
                    }
            }
        
        
       /*stage("Quality Gate"){
            steps{
                withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
                    withSonarQubeEnv('sonarqube'){
                        timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                            //def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                            //if (qg.status != 'OK') {
                            //    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            //}
                            waitForQualityGate abortPipeline: true
                        }
                    }
                }
            }    
        }*/
    }

 post {
	 success {
            sh "echo 'Pipeline reached the finish line!'"
            slackSend (color: '00ff00', message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
         failure {
            sh "echo 'Pipeline failed'"
            slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
      /*always { 
            slack(currentBuild.currentResult)
            cleanWs()

        }*/
    }

}
