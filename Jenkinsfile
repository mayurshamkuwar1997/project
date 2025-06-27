pipeline{
  agent none
  tools{
    maven 'apache-maven-3.9.10'
    }
  options {
    skipDefaultCheckout()
  }
  environment {
    devip= "10.10.1.155"
    qaip= "10.10.2.212"
  }
 stages{
   stage('clonning-git') {
     agent { 
         label 'built-in'
             }
     steps {
       dir('/mnt/project') {
         sh 'rm -rf *'
         checkout scm
             }
          }
        }

   stage('compile-maven') {
      agent {
         label 'built-in'
       }
     steps{
       dir('/mnt/project') {
         sh 'sudo rm -rf /root/.m2/repository'
         sh 'mvn clean install'
         sh 'sudo rm -rf /mnt/wars/*'
         sh 'cp -r target/*.war /mnt/wars'
       }
     }
   }

   stage('copying-war-file-on-dev-and-qa-machines') {
     agent {
       label 'built-in'
           }
     steps {
       sh 'scp -r /mnt/wars/*.war mayur@${devip}:/mnt/wars'
       sh 'scp -r /mnt/wars/*.war mayur@${qavip}:/mnt/wars'
     }
   }

 }
}
