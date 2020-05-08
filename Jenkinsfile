pipeline {
    agent {
            label "docker && linux"
    } 

    environment {
        ONEC_VERSION = vault path: "DevOps/RELEASE_VERSIONS", key: 'ONEC'
        VERSION = vault path: "DevOps/RELEASE_VERSIONS", key: 'EDT'
    }

    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'
                script {  
                    def secrets = [
                        [path: "infastructure/gitlab", engineVersion: 2, secretValues: [
                            [envVar: 'CI_BOT_TOKEN', vaultKey: 'ci-bot']
                        ]],
                        [path: "DevOps/ONEC_RELEASE", engineVersion: 2, secretValues: [
                            [envVar: 'ONEC_USR', vaultKey: 'user'],
                            [envVar: 'ONEC_PSW', vaultKey: 'password']]]
                    ]           
                    withVault([configuration: [timeout: 60], vaultSecrets: secrets ]){ 
                        sh "docker login -u ci-bot -p ${CI_BOT_TOKEN} registry.oskk.1solution.ru"
                        sh "./build.sh"
                        sh "docker push registry.oskk.1solution.ru/docker-images/edt:${VERSION}"
                    }
                }          
            }
        }
    }
}



