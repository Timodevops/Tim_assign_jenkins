# AWS Infrastructure Deployment with Terraform and Jenkins

## 🚀 Project Overview

This project demonstrates the provisioning of AWS infrastructure using **Terraform**, integrated into a **Jenkins CI/CD pipeline** to enable automated, repeatable, and secure deployment of cloud environments.

## 🔧 Tools & Technologies

- **Terraform**
- **AWS** (EC2, VPC, Subnets, Internet Gateway, Security Groups)
- **Jenkins**
- **Git**
- **Linux Shell (Bash)**

## 🌐 Infrastructure Components

- **Custom VPC** with CIDR block `10.0.0.0/16`
- **Two Subnets** across availability zones `us-east-1a` and `us-east-1b`
- **Internet Gateway** for external access
- **Security Group** with rules allowing:
  - ICMP (ping)
  - SSH (port 22)
  - HTTP (port 80)
  - HTTPS (port 443)
- **Three EC2 Instances** launched with specific AMIs and types

## ⚙️ CI/CD Pipeline – Jenkins

A declarative Jenkins pipeline automates the deployment using Terraform:

### Pipeline Stages:
1. **Checkout** – Pulls code from GitHub
2. **Terraform Init** – Initializes the working directory
3. **Terraform Plan** – Creates an execution plan
4. **Terraform Apply** – Applies the changes automatically
5. **Post-Cleanup** – Cleans workspace after each run

## 🔐 Security & IAM

- Uses **Jenkins Credentials Binding Plugin** to securely manage `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- Security groups are defined using Terraform to ensure fine-grained control over inbound and outbound traffic.

## 📝 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/Timodevops/Tim_assign_jenkins.git
   cd Tim_assign_jenkins
