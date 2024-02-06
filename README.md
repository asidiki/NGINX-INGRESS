# Nginx Ingress Tutorial

**_ created by Ansab Sidiki _**

## WHAT:

Goal of this project is to enable Kubernetes Ingress using the Nginx Ingress Controller.

- Create multiple Kubernetes deployments as micro-services.
- Enable logging for the Kubernetes cluster using prometheus and grafana.
- Enable Kubernetes ingress for these pods using Nginx Ingress Controller.
- Enable Kubernetes Ingress across namespaces.

## HOW:

- Create AWS VPC and Deploy Jenkins on a Ec2 instance using terraform.
- Deploy EKS using 'eksctl' with the help of a Jenkins pipeline.
- Deploy two basic Nginx Pods as microservices with the help of ConfigMaps in the default namespace. Route traffic to these services using nginx ingress controller.
- Deploy Nginx Ingress controller in its dedicated namespace.
- Deploy Prometheus and Grafana in the logging namespace, route traffic to these pods using Nginx Ingress controller.
- Setup Grafana dashboard for EKS cluster monitoring.

## Steps:

### Clone repo locally - ` git clone <url>` on your local computer <br>

### Configure awscli:

- Run `aws configure` and set aws environment details for your account on your local computer.

### Deploy Terraform:

- Switch directory to VPC-Jenkins-TF
- rename terraform.tfvars.example to terraform.tfvars and fill out the required instance and subnetting info.
- Initiate terraform by running `terraform init`
- Run ` terraform plan` to ensure correct infrastructure is being deployed. -Optional
- Run `terraform apply -auto-approve` to deploy the infrastructure

### Jenkins Server setup :

- Open a terminal on your local computer and ssh into your jenkins server using your pem key by running `ssh -i "<yourkey>.pem" ubuntu@<IPADDRESS>`
- Verify installation of all the tools that were installed in the bootstrap, ensure you dont get any errors back when you check versions:
  - Jenkins: `jenkins --version`
  - awscli: `aws --version`
  - kubectl: `kubectl version`
  - terraform: `terraform --version`
  - helm: `helm version`
- Run `aws configure` and enter your creds.
- Give jenkins sudo access by editing the Sudoers file.

* `sudo vim /etc/sudoers `
* Add this at the end of the fle `jenkins ALL =(ALL:ALL) NOPASSWD: ALL`

### Configure Jenkins:

- Terraform if successfully deployed, should have outputted the Jenkins server IP. Copy it and paste it in your browser in this format `http://<ipaddress>:8080`.
  Jenkins web UI is exposed at port 8080. you should see the following screen:
  ![jenkins](./images/jenkinsstartup.jpg)
- In your ssh session run cat the file with password by running `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Copy and paste the Admin passwork in the Jenkins setup screen. This should log you in.
- Click on "Install suggested plugins."
- Setup your Admin account on the next screen.
- Complete the setup until you see the following screen:
  ![jenkins](./images/jenkinshome.jpg)
- Click Manage Jenkins > Credentials > Global > Add Credentials.
- Need to add out AWS credentials for jenkins to use for deployments. Do this for both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY:
  ![jenkins](./images/jenkinscred.jpg)
- Add another credentials for git repo login:
  ![jenkins](./images/gitcreds.jpg)

### Edit eksctl_config/cluster_config.yaml:

- In this file edit the subnet information and enter your VPCs private and public subnet IDs. Push changes to your repo.

### Setup EKS Pipeline in Jenkins:

- Click New Item on Jenkins Dashboard and Select Pipeline.
- Scroll down to Pipeline section and change the defition to Pipeline script from SCM, we'll pull the Jenkins pipeline file from our git repo:
  ![pipeline](./images/pipeline.jpg)
- After creating the pipeline, click build now and wait for the EKS cluster to be built in AWS.

### Setup Kubernetes Access:

- On your Jenkins Server run the following command to define which cluster to use:
  `aws eks update-kubeconfig --region us-east-1 --name <cluster-name> `
  -Verify access by running `kubectl get all`

### Create Two Basic Nginx Deployments to route our traffic to:

- Take a look at files in /Kubernetes/Deployments. These are the 2 kubernetes definition files for the microservices we will be deploying to route our traffic to. The Pods use the nginx image and apply some basic config using ConfigMaps.
- On the jenkins server, clone your repo to your desired directory.
- Navigate to the Kubernetes/Deployments folder and Run `kubectl apply -f ./service-a.yaml ` and `kubectl apply -f ./service-b.yaml`
- We just deployed these two micro-services in the default namespace.

### Deploy the Nginx Ingress controller:

- Create a new kubernetes namespace by running `kubectl create namespace ingress-nginx`
- We will use Helm to download the Nginx Ingress controller manifest file:

* Add the repo: `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
* Search the repo for avilable versions: `helm search repo ingress-nginx --versions`

- From the app versions, select the version you want to install:
  `ingress-nginx/ingress-nginx     4.4.0           1.5.1           Ingress controller for Kubernetes using NGINX a...`
- Create Chart Version and App Version Variables:

* `CHART_VERSION="4.4.0"`
* `APP_VERSION="1.5.1"`

- Navigate to Kubernetes/Ingress folder and RUN:
  `helm template ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --version ${CHART_VERSION} --namespace ingress-nginx > ./nginx-ingress.${APP_VERSION}.yaml`
- This will create a manifest file for us to deploy the nginx controller with. We can go in and see what exactly will be deployed.
- RUN `kubectl apply -f nginx-ingress.${APP_VERSION}.yaml `
- To verify got created successfully run `kubectl get all -n ingress-nginx`, should look like this:
  ![ingresscont](./images/ingresscontrol.jpg)
  -Notice the service called ingress-nginx-controller and its "EXTERNAL-IP", thats the FQDN that can use to access resources within our cluster, if you copy and paste that in your browser you should see the following error page:
  ![404](./images/404.jpg)

### Create First Ingress:

- Now that we have our ingress controller setup, we need to tell it how to route traffic by creating an ingress. the yaml file located at Kubernetes/Ingress/Ingress.yaml, does that for us. If you look at it, we are defining route based paths to the two nginx microservices we spun up earlier.
- Navigate to the Ingress directory and edit the file and enter the Loadbalancer FQDN in the 'host' field, without the http://.
  ![host](./images/host.jpg)
- Run `kubectl apply -f Ingress.yaml` to deploy our first ingress in the default namespace to the two microservives. Note the paths we have provided are FQDN/servicea and FQDN/serviceb. Lets test it out in our browser:
  ![servicea](./images/serviceA.jpg) ![serviceb](./images/serviceb.jpg)
- Congratulations, you have successfully deployed two microservices, the nginx ingress controller and successfully routed traffic to them using path based routing by creating an Ingress in the default namespace.
