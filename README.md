**Terraform AWS VPC, EC2 & Application Load Balancer**

This project demonstrates how to provision a basic AWS infrastructure using Terraform, including a custom VPC, subnets, EC2 instances, security groups, and an Application Load Balancer (ALB).

The application runs on multiple EC2 instances, and the Application Load Balancer distributes incoming HTTP traffic between the instances.

**Architecture**

<img width="700" height="500" alt="AWS Terraform Infra" src="https://github.com/user-attachments/assets/2c133cba-7328-481b-8dbb-f8e04549b4f6" />



**AWS Resources**

This Terraform project creates and configures:

1. Custom AWS VPC
2. Public subnets
3. Internet Gateway
4. Route tables and routes
5. Security groups
6. Multiple EC2 instances
7. Apache web server
8. Application Load Balancer
9. ALB Target Group
10. ALB Listener
11. Target group attachments
12. EC2 User Data for server initialization

**Deployment**

1. Clone the repository
   git clone <YOUR-GITHUB-REPOSITORY-URL>
   cd Terraform_vpc_project
2. Initialize Terraform
   terraform init
3. Validate the configuration
   terraform validate
4. Review the execution plan
   terraform plan
5. Create the infrastructure
   terraform apply
6. After Implementing, delete everything
   terraform destroy

**Application Load Balancer**

The Application Load Balancer receives HTTP requests from users and distributes the requests across the EC2 instances registered in the target group.

Refreshing the ALB URL may result in responses from different EC2 instances.

This can be used to demonstrate load balancing by displaying a different message or instance ID on each server.

**Result**

Load Balancer will route the traffic to two instances
