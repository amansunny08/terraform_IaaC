
# Steps to create EC2, VCP, Subnet, Route Table, Internet Gateways and Security Group using Terraform

## Pre-Requisite
1. AWS Access Key 
2. AWS Secret Key
3. AMI ID
4. Region ID 
5. SSH key pair (Generate using ssh-keygen)

**All in one code [Code Example](https://github.com/amansunny08/terraform_IaaC/tree/master/code)**

### Terraform Command.
- terraform init  (To initialize provider plugins, backends, modules )
- terraform fmt (To make proper Formate)
- terraform validate (To validate tf files syntax)
- terraform apply (To create resource)
- terraform destroy (To delete resource)

### Step 1 (provider.tf)

Create and download Access and secet key from AWS console

Get region from AWS console (ex: us-east-1)

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/837918f3-247f-44e9-9a64-93262ac38c4c)

### Step 2 (vpc.tf)

Create new VPC.

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/e755a40e-4c6c-4225-9686-d0678a71bb50)

### Step 3 (subnet.tf)

Create new subnet

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/8c564807-3ef9-49de-9203-d33bb43144c5)

### Step 4 (gw.tf)

Create new Internet Gateways

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/769757fa-61da-4971-95b2-97f034e94b28)

## Step 5 (route_table.tf, route.tf)

Add Route table and associate Subnet

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/88e4624a-d288-4a95-8c76-25b96e79bc93)

### Step 6 (security.tf)

Add Security Group

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/962fbbc6-8ce2-4806-8ac7-f4c63882a044)


### Step 7 (Optional, We can use existing public key) (instance.tf)
Create keypair using ssh-keygen

${path.module} = PWD

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/f6bb33cd-f14b-45b4-8cb3-eb8c50c07a0f)

### Step 8 (instance.tf)

Create Virtual Machine
Get AMI id from AWS console

![image](https://github.com/amansunny08/terraform_ec2/assets/92769620/7357acaa-57ff-45b7-99d4-23d90ba06670)

### Useful outputs (output.tf)
