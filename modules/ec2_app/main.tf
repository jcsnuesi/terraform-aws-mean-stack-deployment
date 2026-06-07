resource "aws_instance" "app_node" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/ami-packer.pem")
    host        = self.public_ip 
}

provisioner "file" {
  source      = "${path.module}/backend"
  destination = "/home/ubuntu/backend"
}

provisioner "file" { 
  source      = "${path.module}/dist/browser"
  destination = "/tmp/new_frontend"
}

provisioner "remote-exec" {
  inline = [
    "sudo apt update -y",
    "sudo apt install -y nodejs npm nginx",
    "cd /home/ubuntu/backend && npm install",
    "sudo rm -rf /var/www/html/*",
    "sudo cp -r /tmp/new_frontend/* /var/www/html/",
    <<-EOT
    sudo bash -c 'cat > /etc/nginx/sites-enabled/default <<EOF
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html;

        server_name _;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
    EOF'
    EOT
    ,
    "sudo chown -R www-data:www-data /var/www/html",
    "sudo systemctl restart nginx"
  ]
}


  tags = {
    Name = "mean-app-${count.index}"
    Role = "AppServer"
  }
}