pipeline {
    environment {
    registry = "ponyo2990/devops-petclinic"
    registryCredential = 'dockerhub'
    dockerImage = ''
    }
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
                sh "./mvnw clean package -Dversion=${BUILD_NUMBER}"
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
                                " -Dsonar.tests=src/test/" +
                                " -Dsonar.junit.reportsPath=target/surefire-reports" +
                                " -Dsonar.jacoco.reportPath=target/jacoco.exec" +
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

	stage("Build Image"){
		steps{
			slackSend (color: '00ff00', message: "Buidling docker image..")
			sh "docker build -t ponyo2990/devops-petclinic:${BUILD_NUMBER} -t ponyo2990/devops-petclinic:lts ."
		}
	}

	stage("push to docker hub"){
		steps{
			slackSend (color: '00ff00', message: "Pushing to DockerHub.")
			withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
          			sh "docker push ponyo2990/devops-petclinic:${BUILD_NUMBER}"
          			sh "docker push ponyo2990/devops-petclinic:lts"
        		}
		}
	}

	stage("deploy to production"){
		input{
			message "Press Ok to continue"
			submitter "manjit"
			parameters {
				string(name:'username', defaultValue: 'user', description: 'Username of the user pressing Ok')
			}
		}
		steps{
			slackSend (color: '00ff00', message: "Deploying to Production: http://localhost:7070/")
			sh "docker run -d -p 7070:8094 ponyo2990/devops-petclinic:lts"
		}
	}	
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
    }

}
