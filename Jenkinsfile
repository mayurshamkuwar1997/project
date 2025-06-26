pipeline{
  agent none 
  tools {
    maven 'apache-maven-3.9.10'
  }
  options {
    skipDefaultCheckout()
  }
  stages{
    stage('clonning-git-repo'){
       agent {
         label 'built-in'
          }
       steps{
         dir('/mnt/project'){
           sh 'rm -rf *'
           checkout scm
           stash includes: 'Dockerfile', name: 'dockerfile'
           stash includes: 'init.sql', name: 'initsql'
            }
         }
      }
    
    stage('adding-path-of-database'){
      agent {
    label 'built-in'
          }
    environment {
         DB_URL = 'jdbc:mysql://database-1.cti0iqs4ugbm.ap-south-1.rds.amazonaws.com:3306/loginwebapp'
         DB_USER = 'admin'
         DB_PASS = 'mayur1997'
       }
     steps{
       dir('/mnt/project/src/main/webapp') {
       sh '''
        sed -i 's|DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");|DriverManager.getConnection("DB_URL_PLACEHOLDER", "DB_USER_PLACEHOLDER", "DB_PASS_PLACEHOLDER");|' userRegistration.jsp
        
        sed -i "s|DB_URL_PLACEHOLDER|${DB_URL}|" userRegistration.jsp
        sed -i "s|DB_USER_PLACEHOLDER|${DB_USER}|" userRegistration.jsp
        sed -i "s|DB_PASS_PLACEHOLDER|${DB_PASS}|" userRegistration.jsp
        '''
          }
      }
    }

 stage('build with maven') {
    agent {
      label 'built-in'
    }
    steps {
      dir('/mnt/project') {
        sh 'rm -rf /root/.m2/repository'
        sh 'mvn clean install'
        stash includes: 'target/*.war', name: 'warfile'
      }
    }
  }

    stage('docker-serverstart-&&-creating-custom-network') {
     agent{
       label 'slave-2'
          }
      steps{
        sh 'sudo systemctl enable docker'
        sh 'sudo docker network create net-1 --driver=bridge'
           }
    }

    stage('making-container-with-network-net-1'){
      agent{ label 'slave-2'}
      steps{
        unstash 'dockerfile'
        unstash 'initsql'
        sh 'sudo chmod -R 777 /mnt/slave-2/workspace/docker-container-tomcat-mysql-database-with-network/Dockerfile'
        sh 'sudo chmod -R 777 /mnt/slave-2/workspace/docker-container-tomcat-mysql-database-with-network/init.sql'
        sh 'sudo docker build -t mysql-container .'
        sh 'sudo docker run -dp 3306:3306 --network net-1 --name sql-container mysql-container'
      }
    }

    stage('making-tomcat-server-&&-deploying-war-file'){
      agent { label 'slave-2'}
      steps{
        sh 'sudo docker run -dp 8080:8080 --network net-1 --name tomcat-container tomcat:10'
        unstash 'warfile'
        sh 'sudo docker cp /target/*.war tomcat-container:/mnt/apache-tomcat-10.1.42/webapps'
      }
    }
    
  }
}
