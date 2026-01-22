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

            stage('docker as build'){
                steps{
                    script{
                           def IMAGE_NAME = JOB_NAME.replaceAll('[^a-zA-Z0-9_.-]', '-').toLowerCase()

                         sh "docker build -t ${IMAGE_NAME}:v1.${BUILD_ID} ."
                         sh "docker tag ${IMAGE_NAME}:v1.${BUILD_ID} nprasanth41/${IMAGE_NAME}:v1.${BUILD_ID}"
                         sh "docker tag ${IMAGE_NAME}:v1.${BUILD_ID} nprasanth41/${IMAGE_NAME}:latest"
                    }
                    }
                }
                stage('push image to docker registry'){
                    steps{
                        script{
                                   def IMAGE_NAME = JOB_NAME.replaceAll('[^a-zA-Z0-9_.-]', '-').toLowerCase()

                                   withCredentials([string(credentialsId: 'docker-auth', variable: 'DOCKER_PASSWORD')]) {
                                  sh """
                                   echo "$DOCKER_PASSWORD" | docker login -u nprasanth41 --password-stdin
                                   docker push nprasanth41/${IMAGE_NAME}:v1.${BUILD_ID}
                                    docker push nprasanth41/${IMAGE_NAME}:latest
                                      """
                        }
                    }
                }
            }
             }
}

           
       
