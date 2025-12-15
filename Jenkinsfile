pipeline {
  agent any
  environment {
    Github_cred    = "Github-cred"
    Dockerhub_cred = "Dockerhub-cred"
    Frontend_image = "mern/frontend"
    Backend_image  = "mern/backend"
    TAG = "${BUILD_NUMBER}"
  }
  stages{
    stage('Pull from git') {
      steps {
           git(
                url: 'https://github.com/horrondor/Devops_final_project.git',
                branch: 'main',
                credentialsId: ${Github_cred}
              )
      }
    }
    stage ('Make Docker images'){
      steps {
        echo "Creating frontend image"
        // sh "docker build -t ${Frontend_image}:${TAG} ."

        // echo "Creating Backend image"
        // sh "docker build -t ${Backend_image}:${TAG} ."
        sh "docker-compose build"
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
          ${Frontend_image}:${TAG}
         """

        echo "Scaning Backend images"
        sh """
          trivy image \
          --timeout 10m\
          --scanners vuln\
          --exit-code 1\
          --severity HIGH,CRITICAL\
          --ignore-unfixed\
          ${Backend_image}:${TAG}
         """ 
      }
    }
    stage ('Push docker images'){
      steps {
        echo "Pushing docker images"
        sh """
          docker-compose push
        """
      }
    }
    stage ('Deploy dev instance'){
      steps {
        echo "Deploying to dev env"
      }
    }
     stage ('Deploy prod instance'){
      steps {
        echo "Deploying to prod env"
      }
    }
  }

  post {
    always {
      mail to: 'horrondor170@gmail.com',
      subject: "Job '${JOB_NAME}' (${TAG}) is running",
      body: "Please go to ${BUILD_URL} and verify the build"
     }

    success {
      mail bcc: '', body: """Hi Team,

	    Build #$BUILD_NUMBER is successful, please go through the url

	    $BUILD_URL

    	and verify the details.

	    Regards,
	    DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'horrondor170@gmail.com'
    }

    failure{
      mail bcc: '', body: """Hi Team,
            
	    Build #$BUILD_NUMBER is unsuccessful, please go through the url

	    $BUILD_URL

	    and verify the details.

	    Regards,
	    DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'horrondor170@gmail.com'
    }
  }
}
