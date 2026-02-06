---

# Task 4 – Terraform Infrastructure with Dockerized Strapi Application

## Project Overview

In this project, I used Terraform to provision AWS infrastructure using Infrastructure as Code (IaC) best practices. Along with infrastructure provisioning, I containerized a Strapi application using Docker and deployed it on an EC2 instance behind an Application Load Balancer (ALB).

---

## Architecture Overview

The infrastructure provisioned using Terraform consists of the following components:

* Custom VPC
* Public subnets for the Application Load Balancer
* Private subnets for the EC2 instance
* Internet Gateway and route tables for public access
* Security Groups following least-privilege principles
* Application Load Balancer (ALB) in public subnets
* Target Group associated with the ALB
* EC2 instance in a private subnet
* Dockerized Strapi application running inside EC2

Traffic flow:
Client → Application Load Balancer (public) → EC2 (private) → Dockerized Strapi application

---

## Docker and Application Setup

To standardize the application runtime and avoid manual dependency installation on EC2, I containerized the Strapi application using Docker.

### Docker Usage

* A Strapi application was created locally.
* A Dockerfile was written to build the Strapi application into a Docker image.
* The Docker image was built locally and pushed to Docker Hub.
* The EC2 instance pulls the Docker image from Docker Hub during boot using user_data.
* The Strapi container runs on port 1337 inside the EC2 instance.

Docker benefits in this project:

* Consistent application runtime across environments
* No need to install Node.js or Strapi manually on EC2
* Faster and more reliable deployments
* Clear separation between infrastructure and application

---

## EC2 Bootstrapping with user_data

The EC2 instance is configured using a user_data script that runs on first boot. The script performs the following actions:

* Updates the operating system
* Installs Docker
* Starts and enables the Docker service
* Pulls the Strapi Docker image from Docker Hub
* Runs the Strapi container on port 1337

This approach ensures the EC2 instance is fully automated and does not require manual configuration after launch.

---

## Terraform Project Structure

The Terraform configuration follows a modular structure to improve readability and maintainability.

task4/
├── README.md
├── provider.tf
├── backend.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
├── userdata.sh
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml



---

## Best Practices Followed

* Used Terraform modules to separate infrastructure components
* Avoided hardcoding values by using variables and tfvars
* Used outputs to pass values between Terraform modules
* Applied least-privilege security group rules
* Deployed EC2 in private subnets for security
* Exposed the application only through an Application Load Balancer
* Used Docker to package and run the application
* Used user_data for automated EC2 bootstrapping
* Maintained clean, readable, and reusable Terraform code

---

## Key Learnings

* Designing modular Terraform configurations
* Understanding VPC, subnet, and routing relationships
* Correct integration of ALB with EC2 instances
* Importance of subnet and availability zone alignment
* Containerizing applications using Docker
* Automating application deployment using EC2 user_data
* Separating infrastructure responsibilities from application concerns

---

**Challenges Faced**
I faced challenges with ALB and EC2 integration, including unhealthy targets and 502 errors due to subnet, availability zone, and target group mismatches. Running Strapi directly using EC2 user_data caused dependency and startup issues, which were hard to debug since user_data executes only once. Limited SSH access to private EC2 instances further increased debugging complexity.

**Why Docker Was Used**
Docker was used to ensure consistent application behavior across environments by packaging Strapi and its dependencies into a single image. This simplified EC2 setup by reducing user_data complexity and made deployments more reliable and repeatable.



## Current Status

* Terraform code is structured correctly and follows best practices
* AWS infrastructure provisioning works as expected
* Dockerized Strapi application deployment is automated through user_data

---

## Conclusion

This project helped me gain hands-on experience with Terraform, AWS infrastructure design, and Docker-based application deployment. The key takeaway was learning how to combine Infrastructure as Code with containerization to build secure, scalable, and maintainable cloud infrastructure.

---

