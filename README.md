# Terraform MEAN Stack Deployment on AWS

This repository provisions the infrastructure required to deploy a basic MEAN stack application on AWS using Terraform.

It creates public application instances behind an Application Load Balancer, a private MongoDB instance, and a NAT Gateway so private resources can reach the internet for package installation and updates.

## English

### Architecture

```text
Internet
   |
   v
Application Load Balancer :80
   |
   v
EC2 App Servers :80
   |
   v
MongoDB EC2 Instance in Private Subnet

Private Subnet -> NAT Gateway -> Internet
```

### What This Deploys

- AWS provider configured from `var.az`.
- Two EC2 application instances using `t3.micro`.
- NGINX installed on the application instances to serve the Angular frontend.
- Node.js and npm installed on the application instances for the backend package setup.
- Angular browser build copied to `/var/www/html`.
- MongoDB EC2 instance deployed in a private subnet.
- MongoDB 6.0 installed through `user_data`.
- NAT Gateway with an Elastic IP for private subnet outbound internet access.
- Private route table associated with the database subnet.
- Public Application Load Balancer listening on HTTP port `80`.
- Target group that forwards traffic to the application instances on port `80`.

### Repository Structure

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules
│   ├── ec2_app
│   ├── ec2_db
│   ├── elb
│   └── nat
└── angular
    └── mean-stack
```

### Prerequisites

- Terraform installed locally.
- AWS account with permissions to create EC2, ALB, NAT Gateway, Elastic IP, routes, and target groups.
- AWS credentials configured locally, for example with environment variables or `aws configure`.
- Existing VPC.
- At least two public subnets for the Application Load Balancer.
- One private subnet for MongoDB.
- Existing security groups for the app servers, database, and load balancer.
- Existing EC2 key pair.
- A valid Ubuntu-compatible AMI ID.
- Private key file available where the EC2 app module expects it: `modules/ec2_app/ami-packer.pem`.

### Required Security Group Rules

The Terraform code expects security groups to already exist. Recommended rules:

| Security Group | Inbound Rules                                                            | Notes                        |
| -------------- | ------------------------------------------------------------------------ | ---------------------------- |
| ALB SG         | HTTP `80` from `0.0.0.0/0`                                               | Public entry point           |
| App SG         | HTTP `80` from ALB SG, SSH `22` from trusted IPs                         | Serves Angular through NGINX |
| DB SG          | MongoDB `27017` from App SG, SSH `22` from trusted IPs or bastion access | Should not be public         |

### Variables

Set the values in `terraform.tfvars` before running Terraform:

```hcl
ami_id            = "ami-xxxxxxxxxxxxxxxxx"
vpc_id            = "vpc-xxxxxxxxxxxxxxxxx"
public_subnet_id  = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
private_subnet_id = "subnet-zzzzzzzzzzzzzzzzz"
key_name          = "your-key-name"
app_sg_id         = "sg-appxxxxxxxxxxxx"
db_sg_id          = "sg-dbxxxxxxxxxxxxx"
elb_sg_id         = "sg-elbxxxxxxxxxxxx"
az                = "us-east-1"
```

> Note: despite the variable name `az`, the AWS provider uses this value as the AWS region.

### Deployment

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

Confirm with `yes` when Terraform asks for approval.

### Outputs

After a successful deployment, Terraform returns:

- `app_public_ips`: public IPs of the application EC2 instances.
- `app_private_ips`: private IPs of the application EC2 instances.
- `db_private_ip`: private IP of the MongoDB EC2 instance.
- `alb_dns`: DNS name used to access the application through the load balancer.
- `nat_ip`: public Elastic IP attached to the NAT Gateway.

Open the application using:

```text
http://<alb_dns>
```

### Destroy

To remove all resources created by this configuration:

```bash
terraform destroy
```

### Security Notes

- Do not commit `.pem` private keys.
- Do not commit `terraform.tfstate` or `terraform.tfstate.backup`, because state files can contain sensitive infrastructure data.
- Restrict SSH access to trusted IP addresses only.
- Keep MongoDB in a private subnet and allow access only from the application security group.
- Review NAT Gateway costs before leaving the environment running.

---

## Español

### Arquitectura

```text
Internet
   |
   v
Application Load Balancer :80
   |
   v
Servidores EC2 de Aplicacion :80
   |
   v
Instancia EC2 MongoDB en Subred Privada

Subred Privada -> NAT Gateway -> Internet
```

### Que Despliega Este Proyecto

- Proveedor de AWS configurado desde `var.az`.
- Dos instancias EC2 para la aplicacion usando `t3.micro`.
- NGINX instalado en las instancias de aplicacion para servir el frontend Angular.
- Node.js y npm instalados en las instancias de aplicacion para preparar el backend.
- Build de Angular copiado en `/var/www/html`.
- Instancia EC2 con MongoDB desplegada en una subred privada.
- MongoDB 6.0 instalado mediante `user_data`.
- NAT Gateway con Elastic IP para que la subred privada tenga salida a internet.
- Tabla de rutas privada asociada a la subred de base de datos.
- Application Load Balancer publico escuchando por HTTP en el puerto `80`.
- Target group que envia trafico a las instancias de aplicacion por el puerto `80`.

### Estructura Del Repositorio

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules
│   ├── ec2_app
│   ├── ec2_db
│   ├── elb
│   └── nat
└── angular
    └── mean-stack
```

### Prerrequisitos

- Terraform instalado localmente.
- Cuenta de AWS con permisos para crear EC2, ALB, NAT Gateway, Elastic IP, rutas y target groups.
- Credenciales de AWS configuradas localmente, por ejemplo con variables de entorno o `aws configure`.
- VPC existente.
- Al menos dos subredes publicas para el Application Load Balancer.
- Una subred privada para MongoDB.
- Security groups existentes para los servidores de aplicacion, la base de datos y el balanceador.
- Key pair de EC2 existente.
- AMI ID valida y compatible con Ubuntu.
- Archivo de llave privada disponible donde el modulo de aplicacion lo espera: `modules/ec2_app/ami-packer.pem`.

### Reglas Recomendadas Para Security Groups

El codigo Terraform espera que los security groups ya existan. Reglas recomendadas:

| Security Group | Reglas De Entrada                                                        | Notas                    |
| -------------- | ------------------------------------------------------------------------ | ------------------------ |
| ALB SG         | HTTP `80` desde `0.0.0.0/0`                                              | Punto de entrada publico |
| App SG         | HTTP `80` desde el ALB SG, SSH `22` desde IPs confiables                 | Sirve Angular con NGINX  |
| DB SG          | MongoDB `27017` desde el App SG, SSH `22` desde IPs confiables o bastion | No debe ser publico      |

### Variables

Configura los valores en `terraform.tfvars` antes de ejecutar Terraform:

```hcl
ami_id            = "ami-xxxxxxxxxxxxxxxxx"
vpc_id            = "vpc-xxxxxxxxxxxxxxxxx"
public_subnet_id  = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
private_subnet_id = "subnet-zzzzzzzzzzzzzzzzz"
key_name          = "your-key-name"
app_sg_id         = "sg-appxxxxxxxxxxxx"
db_sg_id          = "sg-dbxxxxxxxxxxxxx"
elb_sg_id         = "sg-elbxxxxxxxxxxxx"
az                = "us-east-1"
```

> Nota: aunque la variable se llama `az`, el proveedor de AWS usa este valor como region.

### Despliegue

Inicializa Terraform:

```bash
terraform init
```

Revisa el plan de ejecucion:

```bash
terraform plan
```

Aplica la infraestructura:

```bash
terraform apply
```

Confirma con `yes` cuando Terraform solicite aprobacion.

### Outputs

Despues de un despliegue exitoso, Terraform retorna:

- `app_public_ips`: IPs publicas de las instancias EC2 de aplicacion.
- `app_private_ips`: IPs privadas de las instancias EC2 de aplicacion.
- `db_private_ip`: IP privada de la instancia EC2 con MongoDB.
- `alb_dns`: DNS para acceder a la aplicacion mediante el balanceador.
- `nat_ip`: Elastic IP publica asociada al NAT Gateway.

Abre la aplicacion usando:

```text
http://<alb_dns>
```

### Destruir La Infraestructura

Para eliminar todos los recursos creados por esta configuracion:

```bash
terraform destroy
```

### Notas De Seguridad

- No subas llaves privadas `.pem` al repositorio.
- No subas `terraform.tfstate` ni `terraform.tfstate.backup`, porque los archivos de estado pueden contener datos sensibles de infraestructura.
- Restringe el acceso SSH solo a direcciones IP confiables.
- Mantén MongoDB en una subred privada y permite acceso solo desde el security group de aplicacion.
- Revisa los costos del NAT Gateway antes de dejar el ambiente encendido.
