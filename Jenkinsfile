pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/terraform-aws.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    //     stage('Terraform Destroy') {
    //         steps {
    //             sh 'terraform destroy -auto-approve tfplan'
    //         }
    //     }
    // }

    post {
        always {
            cleanWs()
        }
    }
}
