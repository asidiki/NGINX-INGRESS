# Nginx Ingress Tutorial

**_ created by Ansab Sidiki _**

## WHAT:

Goal of this project is to enable Kubernetes Ingress using the Nginx Ingress Controller. - Create multiple Kubernetes deployments as micro-services. - Enable logging for the Kubernetes cluster using prometheus and grafana. - Enable Kubernetes ingress for these pods using Nginx Ingress Controller. - Enable Kubernetes Ingress across namespaces.

## HOW:

- Create AWS VPC and Deploy Jenkins on a Ec2 instance using terraform.
- Deploy EKS using 'eksctl' with the help of a Jenkins pipeline.
- Deploy Nginx Ingress controller in its dedicated namespace.
- Deploy two basic Nginx Pods as microservices with the help of ConfigMaps in the default namespace. Route traffic to these services using nginx ingress controller.
- Deploy Prometheus and Grafana in the logging namespace, route traffic to these pods using Nginx Ingress controller.
- Setup Grafana dashboard for EKS cluster monitoring.

## Steps:

### Clone repo locally - ` git clone <url>` <br>

### Configure awscli:

    - Run ``` aws configure ``` and set aws environment details for your account.

### Deploy Terraform:

    - Switch directory to VPC-Jenkins-TF
    - rename terraform.tfvars.example to terraform.tfvars and fill out the required instance and subnetting info.
    - Initiate terraform by running ``` terraform init ```
    - Run ``` terraform plan``` to ensure correct infrastructure is being deployed. -Optional
    - Run ``` terraform apply -auto-approve ``` to deploy the infrastructure

### Configure Jenkins:

    - Terraform if successfully deployed, should have outputted the Jenkins server IP. Copy it and paste it in your browser in this format ```http://<ipaddress>:8080```.
    Jenkins web UI is exposed at port 8080. you should see the following screen:

![jenkins](\images\jenkinsstartup.jpg)
