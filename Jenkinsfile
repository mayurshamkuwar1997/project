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
      dir('/mnt/project-2') {
        sh 'rm -rf /root/.m2/repository'
        sh 'mvn clean install'
        stash includes: 'target/*.war', name: 'warfile'
      }
    }
  }

    stage('creating-ntwork')
     agent{
       label 'uat'
     }
      steps{
        sh 'sudo docker network net-1 --driver=bridge'
        
      }
    }
    
    
  }
}
