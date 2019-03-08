pipeline {
    agent any
        tools {
            maven 'maven'
        }
    stages {
        stage('checkout'){
            steps {
                git branch: 'master',
                url: 'https://github.com/ponyo2990/spring-petclinic'
            }
        }
        stage('Build') {
            steps {
               sh 'chmod u+x mvnw'
               sh './mvnw package'
            }
        }
        
        stage('JMX_test') {
            steps{
                sh 'jmeter -n -t /src/test/jmeter/petclinic_test_plan.jmx'
            }
        }
    }
    post {
        success {
         sh "echo 'Pipeline reached the finish line!'"
         }
        failure {
            sh "echo 'Pipeline failed'"
         }
    }
}
