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
         DB_PASS = '123456'
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
    
   stage('adding-maven'){
         agent {
           label 'built-in'
          }
      steps {
       dir('/mnt/project') {
       sh 'rm -rf /root/.m2/repository'
       sh 'mvn clean install'
       stash name: 'warfile', includes: 'target/*.war'
       }
       }
    }
    
    stage('build-war') {
       agent {
      label 'slave-1'
             }
      steps{
        unstash name: 'warfile'
        sh 'sudo cp target/*.war /mnt/apache-tomcat-10.1.42/webapps'
        sh '''
        sudo chmod -R 777 /mnt/apache-tomcat-10.1.42
        cd /mnt/apache-tomcat-10.1.42/bin
        sudo ./startup.sh
        '''
      }
    }
    
  }
}
