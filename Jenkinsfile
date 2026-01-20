pipeline{
    
    agent { label 'slavee1' }
    stages {
        stage('Git Checkout'){            
            steps{            
                script{                    
                    git branch: 'main', url: 'https://github.com/nanneboinaprasanth/demo-counter-app.git'
                }
            }
        }
        stage('UNIT testing'){
            steps{            
                script{                   
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){            
            steps{                
                script{                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){           
            steps{              
                script{                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static Code Analysis') {
    steps {
        withSonarQubeEnv('sonarqube-server') {
            sh 'mvn clean verify sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){                
                steps{                 
                    script{                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonarauth'
                    }
                }
            }
        }        
}
