pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "us-east-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Timodevops/Tim_assign_jenkins.git'
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

        stage('Approval') {
            steps {
                sh 'terraform apply tfplan'
            }
        }
        
        stage('Destroy Resources') {
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }
        
        stage('Clean Up') {
            steps {
                sh 'rm -rf .terraform'
                sh 'rm tfplan'
            }
        }
    }
}
