pipeline {
  agent any

  environment {
    IMAGE_NAME = 'your-dockerhub-user/nms-scanner:latest'
    CREDENTIALS_ID = '82e93394-3d04-4444-8216-c9b3b1112240'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[
            url: 'https://github.com/illuspas/Node-Media-Server.git',
            credentialsId: "${CREDENTIALS_ID}"
          ]]
        ])
      }
    }

    stage('Build Scanner Image with Kaniko') {
      steps {
        sh '''
          mkdir -p /kaniko/.docker
          echo '{"auths":{"https://index.docker.io/v1/":{"auth":"REPLACE_WITH_BASE64_AUTH"}}}' > /kaniko/.docker/config.json

          /kaniko/executor \
            --context `pwd`/scanner \
            --dockerfile `pwd`/scanner/Dockerfile \
            --destination=${IMAGE_NAME} \
            --cleanup
        '''
      }
    }

    stage('Run Scanner Container') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/app ${IMAGE_NAME} /app/scan.sh
        '''
      }
    }

    stage('Archive Reports') {
      steps {
        archiveArtifacts artifacts: '**/*.json', allowEmptyArchive: true
      }
    }
  }
}
