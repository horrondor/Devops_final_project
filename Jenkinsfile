pipeline {
  // agent { label 'Jenkins_slave' }
  agent any
  environment {
    Github_cred    = "Github-cred"
    Frontend_image = "raju217/frontend"
    Backend_image  = "raju217/backend"
    KUBECONFIG = credentials('kubeconfig')
    TAG = "${BUILD_NUMBER}"
    scannerHome = tool 'sonarqube8.0'
  }
  stages{
    stage('Pull from git') {
      steps {
           git(
                url: 'https://github.com/horrondor/Devops_final_project.git',
                branch: 'final',
                credentialsId: "${Github_cred}"    
              )
      }
    }
    // stage('Sonarqube scanner'){ 
    //   steps{ 
    //     withSonarQubeEnv('SonarQube') { 
    //       sh """
    //         ${scannerHome}/bin/sonar-scanner \
    //         -Dsonar.projectKey=mern-devops-project \
    //         -Dsonar.projectName=mern-devops-project \
    //         -Dsonar.projectVersion=${TAG} \
    //         -Dsonar.sources=mern \
    //         -Dsonar.sourceEncoding=UTF-8
            
    //       """
    //     } 
    //   } 
    // }
    stage ('Make Docker images'){
      steps {
        echo "Creating frontend image"
        sh "docker build -t ${Frontend_image}:${TAG} ${env.WORKSPACE}/mern/frontend"

        // echo "Creating Backend image"
        sh "docker build --no-cache -t ${Backend_image}:${TAG} ${env.WORKSPACE}/mern/backend"
        // sh "docker compose build"
      }
    }
    stage ('scan docker image'){
      steps {
        echo "Scaning Frontend  images"
        sh """
          trivy image \
          --timeout 10m\
          --scanners vuln\
          --exit-code 1\
          --severity HIGH,CRITICAL\
          --ignore-unfixed\
          ${Frontend_image}:${TAG} \
          || true
         """

        echo "Scaning Backend images"
        sh """
          trivy image \
          --timeout 10m \
          --scanners vuln\
          --exit-code 1\
          --severity HIGH,CRITICAL\
          --ignore-unfixed\
          ${Backend_image}:${TAG} \
          || true
         """ 
      }
    }
    stage ('Push docker images'){
      steps {
        echo "Pushing docker images"
          withDockerRegistry([credentialsId: 'Dockerhub-cred', url: '']){
           sh """
             docker push ${Frontend_image}:${TAG} 
             docker push ${Backend_image}:${TAG}  
           """
          }
        
      }
    }
    stage ('Deploy dev instance'){
      steps {
        echo "Deploying to dev env"
      }
    }
    // stage('Test Kubernetes Access') {
    //   steps {
    //     sh 'kubectl get nodes'
    //   }
    // }
    stage ('Deploy prod instance'){
      steps {
        echo "Deploying to prod env"
        timeout(time:1, unit:'HOURS'){
        input message:'Approve PRODUCTION Deployment?'
        }
        sh """
          export KUBECONFIG=${KUBECONFIG}
          envsubst < ./k8-deployment/local-storageclass.yml | kubectl apply -f -
          envsubst < ./k8-deployment/mongo_pv.yml | kubectl apply -f -
          envsubst < ./k8-deployment/mongo_pvc.yml | kubectl apply -f -
          envsubst < ./k8-deployment/mongo_service.yml | kubectl apply -f -
          envsubst < ./k8-deployment/mongo_statefulset.yml | kubectl apply -f -
          envsubst < ./k8-deployment/frontend_deployment.yml | kubectl apply -f -
          envsubst < ./k8-deployment/frontend_service.yml | kubectl apply -f -
          envsubst < ./k8-deployment/backend_deployment.yml | kubectl apply -f -
          envsubst < ./k8-deployment/backend_service.yml | kubectl apply -f -
        """
      }
    }
  }

  // post {
  //   always {
  //     mail to: 'horrondor170@gmail.com',
  //     subject: "Job '${JOB_NAME}' (${TAG}) is running",
  //     body: "Please go to ${BUILD_URL} and verify the build"
  //    }

  //   success {
  //     mail bcc: '', body: """Hi Team,

	//     Build #$BUILD_NUMBER is successful, please go through the url

	//     $BUILD_URL

  //   	and verify the details.

	//     Regards,
	//     DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'horrondor170@gmail.com'
  //   }

  //   failure{
  //     mail bcc: '', body: """Hi Team,
            
	//     Build #$BUILD_NUMBER is unsuccessful, please go through the url

	//     $BUILD_URL

	//     and verify the details.

	//     Regards,
	//     DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'horrondor170@gmail.com'
  //   }
  // }
}
