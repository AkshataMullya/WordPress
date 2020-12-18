pipeline {
    environment {
        registry = "169395/mywordpresswebsite"
        registryCredential = 'akshata@123'
        prodImage = ''
        PROD_DB_HOST = credentials('wordpress.cikrt1wxrd3j.us-east-1.rds.amazonaws.com')
        PROD_DB_DATABASE = credentials('wordpress')
        PROD_DB_USERNAME = credentials('wordpress')
        PROD_DB_PASSWORD = credentials('akshata!99')
        PROD_AUTH_KEY_VAL = credentials('PROD_AUTH_KEY_VAL')
        PROD_SECURE_AUTH_KEY = credentials('PROD_SECURE_AUTH_KEY')
        PROD_LOGGED_IN_KEY = credentials('PROD_LOGGED_IN_KEY')
        PROD_NONCE_KEY = credentials('PROD_NONCE_KEY')
        PROD_AUTH_SALT = credentials('PROD_AUTH_SALT')
        PROD_SECURE_AUTH_SALT = credentials('PROD_SECURE_AUTH_SALT')
        PROD_LOGGED_IN_SALT = credentials('PROD_LOGGED_IN_SALT')
        PROD_NONCE_SALT = credentials('PROD_NONCE_SALT')
    }
    agent none
    stages {
        stage('Build Prod') {
            agent {
                label 'master'
            }
            steps {
                echo 'Building Production....'
 
 
                script{
                    // build & push our docker image
                    prodImage = docker.build((registry+":${env.BUILD_NUMBER}"),
                        "-t "+registry+":${env.BUILD_NUMBER} " +
                        "-t "+registry+":latest " +
                        "--build-arg build_version=${env.BUILD_NUMBER} " +
                        "--build-arg db_host=$PROD_DB_HOST " +
                        "--build-arg db_database=$PROD_DB_DATABASE " +
                        "--build-arg db_username=$PROD_DB_USERNAME " +
                        "--build-arg db_password=$PROD_DB_PASSWORD " +
                        "--build-arg auth_key_val='$PROD_AUTH_KEY_VAL' " +
                        "--build-arg sercure_auth_key_val='$PROD_SECURE_AUTH_KEY' " +
                        "--build-arg logged_in_key_val='$PROD_LOGGED_IN_KEY' " +
                        "--build-arg nonce_key_val='$PROD_NONCE_KEY' " +
                        "--build-arg auth_salt_val='$PROD_AUTH_SALT' " +
                        "--build-arg secure_auth_salt_val='$PROD_SECURE_AUTH_SALT' " +
                        "--build-arg logged_in_salt_val='$PROD_LOGGED_IN_SALT' " +
                        "--build-arg nonce_salt_val='$PROD_NONCE_SALT' " +
                        "--file Dockerfile .")
                    docker.withRegistry( '', registryCredential) {
                        prodImage.push("latest")
                    }
                }
            }
        }
        stage('Clean Up') {
            agent {
                label 'master'
            }
            steps {
                echo 'Removing docker images....'
                sh 'docker system prune -af --volumes'
            }
        }
    }
    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                    subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
 
        }
    }
}
