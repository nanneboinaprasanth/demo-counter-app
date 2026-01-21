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
            stage('Quality Gate Status'){                
                steps{                 
                    script{                        
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
             stage('nexus update'){
                steps{
            
                  script {
                          def pom = readMavenPom file: 'pom.xml'

                             def nexusRepo = pom.version.endsWith('SNAPSHOT') ?
                                  'java-snapshot1' :
                                   'java-release'

                            nexusArtifactUploader(
                            artifacts: [
                              [
                                    artifactId: 'springboot',
                                      classifier: '',
                                       file: 'target/Uber.jar',
                                        type: 'jar'
                                    ]
                                      ],
                                      credentialsId: 'nexus-auth',
                                      groupId: 'com.example',
                                      nexusUrl: '172.31.10.96:8081',
                                      nexusVersion: 'nexus3',
                                      protocol: 'http',
                                      repository: nexusRepo,
                                      version: pom.version
    )
}

                       
                    }
                }
             }
        }   
       
