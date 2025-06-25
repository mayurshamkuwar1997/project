pipeline{
  agent none 
  tools{
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
      checkout scm
            }
       }
        }
    stage('adding-maven'){
         agent {
           label 'built-in'
          }
      steps {
       dir('/mnt/project') {
       sh 'rm -rf /.m2/repository'
       sh 'mvn clean install'
       stash name: 'warfile', includes: 'target/*.war'
       }
       }
    }
    stage('adding-path-of-database'){
      agent {
    label 'built-in'
          }
     steps{
       dir('/mnt/project/src/main/webapp')
       sh '''
        sed -i 's|DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root")|DriverManager.getConnection("jdbc:mysql://database-1.cti0iqs4ugbm.ap-south-1.rds.amazonaws.com:3306/loginwebapp", "admin", "123456")|g' userRegistration.jsp
        '''
          }
    }
   
    stage('build-war') {
       agent {
      label 'slave-1'
             }
      steps{
        unstash name: 'warfile'
        sh '''
        cp /mnt/project/target/*.war /mnt/apache-tomcat-10.1.42/webapps
        chmod -R 777 /mnt/apache-tomcat-10.1.42
        cd /mnt/apache-tomcat-10.1.42/bin
        ./startup.sh
        '''
        
      }
    }
  }
}
