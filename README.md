# Project Name : Trust Me, I’m a DevOps Engineer

## 🏗️ 1. Project Overview & Design Philosophy

This project implements a **secure, scalable, and fully automated cloud environment** on AWS, designed and delivered using modern DevOps practices.

The architecture is intentionally built around **Least Privilege** and **Defense in Depth** principles. All control-plane components (configuration management, monitoring, and administration) are isolated within private subnets and are **never directly exposed to the public internet**.Public exposure is strictly limited to the application entry point and tightly controlled.


<p style="text-align: center;">
  <img src="./asset/diagram.png" alt="Architecture diagram" style="display: block; margin-left: auto; margin-right: auto; max-width: 100%;" />
  <em>Diagram 1: Architecture Diagram</em>
</p>

### Core Technical Stack:
- **Infrastructure as Code (IaC):** Terraform (Modularized infrastructure provisioning)
- **Configuration Management:** Ansible (Idempotent configuration & application lifecycle)
- **Containerization:** Docker (Containerized service delivery)
- **Observability:** Prometheus & Grafana (System-wide metrics & visualization)
- **Security & Access:**  
  - Cloudflare Zero Trust (secure tunneling)  
  - AWS Systems Manager (SSM) (agent-based access and operations)

## 🔗 2. Deployment Endpoints

| Component | Access Method | URL |
|----------|---------------|-----|
| Web Application | Public (Elastic IP) | http://web.cheamirul.site |
| Monitoring (Grafana) | Cloudflare Tunnel | https://monitoring.cheamirul.site |
| GitHub Repository | GitHub | https://github.com/cheamirul/devops-bootcamp-project |

## 🛠️ 3. Infrastructure Provisioning (Terraform)

The infrastructure is fully defined in HCL and managed via Terraform to ensure reproducibility across environments.

### 3.1 State Management

- Backend: Amazon S3 is used to store Terraform state as a single source of truth.
- Consistency: Remote state management helps prevent configuration drift and supports safe collaboration.

### 3.2 Network Architecture

- VPC: `10.0.0.0/24`
- Public Subnet: `10.0.0.0/25`
- Private Subnet: `10.0.0.128/25`
- Internet Gateway attached to the public subnet
- NAT Gateway enables outbound internet access for private instances without exposing them publicly

This layout enforces a clear separation between **internet-facing workloads** and **internal management components**.

### 3.3 Security Groups

**Public Security Group**
- Port 80: Allowed from any IP (HTTP access)
- Port 22: Allowed only from within the VPC CIDR
- Port 9100: Allowed only from within the VPC CIDR (Prometheus Node Exporter)

**Private Security Group**
- Port 22: Allowed only from within the VPC CIDR

### 3.4 EC2 Instances

| Server | Subnet | Private IP | Public Access |
|------|------|----------|--------------|
| Web Server | Public | 10.0.0.5 | Elastic IP |
| Ansible Controller | Private | 10.0.0.135 | No |
| Monitoring Server | Private | 10.0.0.136 | No |

###  3.5 Container Registry

- Amazon ECR is used as the centralized container registry.
- Application images are built externally and pushed to ECR for deployment.

## ⚙️ 4. Configuration Management (Ansible)

All configuration and deployment activities are executed **centrally from the Ansible Controller**, ensuring consistency and eliminating manual server configuration.

### 4.1 Web Server Configuration

- Docker Engine installed via Ansible
- Web application deployed as a Docker container
- Application exposed on port 80
- Node Exporter installed to expose system metrics for monitoring

### 4.2 Monitoring Server Configuration

- Docker Engine installed via Ansible
- Prometheus deployed using Docker
- Grafana deployed using Docker
- Cloudflared deployed as a Docker container to establish a secure tunnel

## 🤖 5. Monitoring & Observability

### 5.1 Prometheus

Prometheus scrapes system-level metrics from the web server using Node Exporter, focusing on infrastructure health rather than application-specific metrics.

### 5.2 Grafana

Grafana visualizes:
- CPU usage
- Memory usage
- Disk usage

Grafana is **not publicly exposed** and is accessed only via Cloudflare Tunnel, ensuring secure and controlled access.

## 💡 6. Access & Connectivity

### 6.1 AWS Systems Manager (SSM)
- Enabled on all EC2 instances
- Used for secure access, troubleshooting, and operational tasks
- Eliminates the need for public SSH access, reducing the attack surface

### 6.2 Ansible Connectivity
- Ansible connects to servers using private IP addresses
- SSH is used exclusively within the private network boundary

##  🌐 7. Domain & Cloudflare Configuration

The domain is managed via Cloudflare

### Subdomains
- `web.cheamirul.site` → Web Server Elastic IP
- `monitoring.cheamirul.site` → Cloudflare Tunnel endpoint

Monitoring server has no public IP and is not directly exposed.

## 🔁 8. CI/CD Pipeline

### 8.1 Documentation Deployment
- GitHub Pages is enabled
- Documentation is automatically published on pushes to the `main` branch

### 8.2 Container Image Workflow
- GitHub Actions is used to build the Docker image
- Image is pushed to Amazon ECR
- Workflow is triggered manually to maintain deployment control

## 🧭 9. High-Level Deployment Flow

The project was implemented following the sequence below:

1. Generate SSH key pair and put in ansible directory as ansible-key.pem. 
2. Provisioned AWS infrastructure using Terraform, including networking, security groups, EC2 instances, ECR, and remote state storage.
3. Accessed the Ansible Controller via AWS Systems Manager.
4. Configured all servers using Ansible, including Docker installation and application deployment.
5. Deployed the monitoring stack (Prometheus and Grafana) using Docker and configured metric scraping.
6. Configured Cloudflare DNS and Cloudflare Tunnel for secure external access.
7. Enabled GitHub Pages to publish documentation automatically.

## ✅ Summary

This project demonstrates a complete DevOps workflow covering:
- Infrastructure provisioning via Terraform
- Configuration management via Ansible
- Containerized application deployment
- Secure, private monitoring with Prometheus and Grafana
- Controlled access using Cloudflare Tunnel and AWS SSM
- Automated documentation publishing

All components are implemented according to the project requirements and follow industry-standard DevOps practices.
