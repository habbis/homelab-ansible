pipeline {

  agent {
    label 'hf-t-build02-docker'
  }

  stages {

    stage ('Get latest code') {
      steps {
        checkout scm
      }
    }

    stage ('Setup Python virtual environment') {
      steps {
        sh ''' #!/bin/bash
          python3 -m venv virtenv
          . ./virtenv/bin/activate
          python3 -m pip install --upgrade ansible molecule docker
          pip3 install 'molecule[docker]'
        '''
      }
    }

    stage ('Display versions') {
      steps {
        sh '''
          . ./virtenv/bin/activate
          docker -v
          python -V
          ansible --version
          molecule --version
        '''
      }
    }

    stage ('Molecule test') {
      steps {
        sh '''
          . ./virtenv/bin/activate
          molecule test
        '''
      }
    }

  }

}
