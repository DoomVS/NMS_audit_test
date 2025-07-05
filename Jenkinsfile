pipeline {
  agent any

  environment {
    IMAGE_NAME = "doomvs/ci-scanner"
    TAG = "latest"
  }

  stages {
    stage('Prepare') {
      steps {
        sh '''
          rm -rf workspace
          git clone https://github.com/illuspas/Node-Media-Server.git workspace
        '''
      }
    }

    stage('Build image with Kaniko') {
      steps {
        sh '''
          docker run --rm \
            -v $(pwd):/project \
            -v ~/.docker:/kaniko/.docker \
            gcr.io/kaniko-project/executor:latest \
            --dockerfile=/project/Dockerfile \
            --context=/project \
            --destination=docker.io/${IMAGE_NAME}:${TAG} \
            --skip-tls-verify
        '''
      }
    }

    stage('Run scan container') {
      steps {
        sh '''
          docker run --rm \
            -v $(pwd)/workspace:/workspace \
            ${IMAGE_NAME}:${TAG}
        '''
      }
    }

    stage('Archive reports') {
      steps {
        archiveArtifacts artifacts: 'workspace/*.json', fingerprint: true
      }
    }
  }
}
