resource "aws_instance" "mongodb" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "mean-mongodb"
    Role = "MongoDB"
  }



user_data = <<-EOF
            #!/bin/bash
            apt-get update -y           
            apt-get install -y gnupg curl

            # Importa la clave pública de MongoDB
            curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg

            
            echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
            apt-get update -y
            apt-get install -y mongodb-org

            # Habilita y arranca el servicio de MongoDB
            systemctl enable mongod
            systemctl start mongod

            # Crear la base de datos meandb y colección de prueba
            echo 'db.createCollection("init_collection")' | mongo meandb
            EOF
}
