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
                git branch: 'main', url: 'https://github.com/your-repo/terraform-aws-architecture.git'
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
                script {
                    def plan = input message: 'Do you want to apply the Terraform plan?',
                        parameters: [choice(name: 'Action', choices: 'Apply\nDiscard', description: 'Apply or discard the Terraform plan?')]
                    if (plan == 'Apply') {
                        stage('Terraform Apply') {
                            steps {
                                sh 'terraform apply tfplan'
                            }
                        }
                    }
                }
            }
        }
    }
}
