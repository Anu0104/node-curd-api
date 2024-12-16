# Terraform AWS EKS with VPC and ALB Controller For NodeJS CURD API

This Terraform project is designed to create an AWS infrastructure that includes the following components:

- **VPC (Virtual Private Cloud):** Custom VPC for isolating resources.
- **EKS Cluster (Elastic Kubernetes Service):** Managed Kubernetes cluster for containerized applications.
- **AWS Load Balancer Controller:** Deployed within the EKS cluster to manage Application Load Balancers (ALB) for Kubernetes services.

## Prerequisites

Ensure you have the following installed and configured:

1. [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or higher)
2. AWS CLI configured with appropriate credentials and permissions
3. kubectl (Kubernetes CLI)
4. AWS IAM permissions for creating resources (VPC, EKS, IAM roles, ALB, etc.)

## Directory Structure

```
terraform-nodejs-api-infra/
├── cluster.tf                            # EKS module
├── vpc.tf                                # VPC module
├── load-balancer-controller.tf           # AWS Load Balancer Controller setup
├── variable.tf                           # Input variables
├── provider.tf                           # Terraform providers
└── README.md                             # Project documentation
```

## Features

### 1. VPC
- Creates a custom VPC with public and private subnets across multiple availability zones.
- Configures NAT Gateways for internet access to private subnets.
- Outputs subnet IDs and VPC ID for reference.

### 2. EKS Cluster
- Provisions an EKS cluster with the specified number of worker nodes.
- Configures IAM roles and policies for EKS and worker nodes.
- Outputs the kubeconfig file for cluster access.

### 3. AWS Load Balancer Controller
- Installs the AWS Load Balancer Controller using Helm.
- Configures necessary IAM roles and policies for ALB integration.
- Supports the creation of ALBs for Kubernetes Ingress resources.

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Anu0104/nodejs-crud-api.git
   cd terraform-nodejs-api-infra
   ```

2. **Customize variables:**
   Update `variables.tf` or create a `terraform.tfvars` file with your specific values.

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```

6. **Access EKS Cluster:**
   Retrieve the kubeconfig output to access the EKS cluster:
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name>
   ```

7. **Verify EKS cluster is running or not**
   Ensure the nodes are running by using kubectl command:
   ```bash
   kubectl get node 
   ```

8. **Uncomments load-balancer-controller.tf file and helm, kubectl providers from providers.tf file**

9. **Initialize Terraform:**
   ```bash
   terraform init
   ```
9. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```

9. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## Inputs

| Variable Name       | Description                                  | Default         |
|---------------------|----------------------------------------------|-----------------|
| `region`            | AWS region                                  | `us-east-1`     |
| `vpc_cidr`          | CIDR block for the VPC                      | `10.0.0.0/16`   |
| `eks_cluster_name`  | Name of the EKS cluster                     | `my-cluster`    |
| `node_instance_type`| Instance type for worker nodes              | `t3.medium`     |
| `node_count`        | Number of worker nodes                      | `3`             |

## Outputs

| Output Name         | Description                                  |
|---------------------|----------------------------------------------|
| `vpc_id`            | ID of the created VPC                       |
| `eks_cluster_arn`   | ARN of the created EKS cluster              |
| `subnet_ids`        | IDs of the created subnets                  |
| `kubeconfig`        | Kubeconfig file for cluster access          |

## Cleanup

To delete all the resources created by this project, run:

```bash
terraform destroy
```

---
