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
                             sh '''
                                  set -e
                             docker build -t ${JOB_NAME}:v1.${BUILD_ID} .
                             docker tag ${JOB_NAME}:v1.${BUILD_ID} nprasanth41/${JOB_NAME}:v1.${BUILD_ID}
                             docker tag ${JOB_NAME}:v1.${BUILD_ID} nprasanth41/${JOB_NAME}:latest
                             '''
                    }
                    }
                }
                stage('push image to docker registry'){
                    steps{
                        script{
                                    withCredentials([string(credentialsId: 'docker-auth', variable: 'DOCKER_PASSWORD')]) {
                                sh '''
                               set -e
                               echo "$DOCKER_PASSWORD" | docker login -u nprasanth41 --password-stdin
                               docker push nprasanth41/${JOB_NAME}:v1.${BUILD_ID}
                               docker push nprasanth41/${JOB_NAME}:latest
                               '''
                        }
                    }
                }
            }
            stage('Deploy to EKS'){
                steps{
                    script{
                        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                            sh '''
                            set -e
                            aws eks update-kubeconfig --region eu-north-1 --name terraform-eks-cluster
                            kubectl set image deployment/demo-counter-app demo-counter-app=nprasanth41/${JOB_NAME}:v1.${BUILD_ID} -n default
                            kubectl rollout status deployment/demo-counter-app -n default
                            '''
                        }
                    }
                }
            }
             }
}

           
       
