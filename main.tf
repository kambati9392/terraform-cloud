provider "aws" {
    region = "ap-southeast-1"
  
}

# resource "aws_s3_bucket" "state_s3_bucket" {
    
#   bucket = "tfstate-bucket1111"
  
  
#   tags = {
#     Name= "state-bucket"
#   }
# }

#createing an vpc
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name=var.terraform_vpc_name
  }
}
#-----igw-------#
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = var.igw-name
  }
}


# Create Public Subnets

resource "aws_subnet" "terraform_public_subnet_1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = var.public_subnet_az_1
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_1_name
  }
}


resource "aws_subnet" "terraform_public_subnet_2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = var.public_subnet_az_2
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_2_name
  }
}



# Create Private Subnets
resource "aws_subnet" "terraform_private_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = var.private_subnet_az_1
  tags = {
    Name = var.private_subnet_1_name
  }
}

resource "aws_subnet" "terraform_private_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = var.private_subnet_az_2
  tags = {
    Name = var.private_subnet_2_name
  }
}

#------#


resource "aws_route_table" "terraform_public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.terraform_igw.id
  }


  tags = {
    Name = var.ws-pub-route-table
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.terraform_public_subnet_1.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id   = aws_subnet.terraform_public_subnet_2.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}



resource "aws_route_table" "terraform_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = var.ws-pri-route-tabled
  }
}
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.terraform_private_subnet_1.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.terraform_private_subnet_2.id
  route_table_id = aws_route_table.terraform_private_route_table.id
  
}

#----------------#
# Create NAT Gateway in Public Subnet 1
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.terraform_public_subnet_1.id

  tags = {
    Name = var.ws-nat-gate-way
  }
}
# Add Route to Private Route Table for NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.terraform_private_route_table.id
  destination_cidr_block = var.all_traffic
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

#-----------------------------------------------#
#_-----------------------------------------------#

# Create a Security Group
resource "aws_security_group" "terraform_front_ec2_sg" {
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.terraform_vpc.id


  # Allow SSH access
  ingress {
    from_port   = var.port_22
    to_port     = var.port_22
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic] # Restrict this to your IP for better securits
  }

  # Allow HTTP access
  ingress {
    from_port   = var.port_80
    to_port     = var.port_80
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  # Allow all outbound traffic
  egress {
    from_port   = var.port_0
    to_port     = var.port_0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name = var.ws-front-sg-name
  }
}
# # Generate a private key locally
# resource "tls_private_key" "terraform1" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # Create the EC2 Key Pair with the generated public key
# resource "aws_key_pair" "ec2_key_pair_front" {
#   key_name   = "terraform-front-key"
#   public_key = tls_private_key.terraform1.public_key_openssh
# }

# # Save the private key to a file (optional)
# resource "local_file" "private_key" {
#   content  = tls_private_key.terraform1.private_key_pem
#   filename = "terraform-front-key.pem"
# }

#create ec2
resource "aws_instance" "terraform_front_ec2" {
  ami               = var.ws-front-ami
  instance_type     = var.ws-front-ec2-type
  key_name          = var.ws-front-key-name
   subnet_id     = aws_subnet.terraform_public_subnet_1.id 

  security_groups = [aws_security_group.terraform_front_ec2_sg.id] 
 

   provisioner "remote-exec" {
    inline = [
      # Create the file and set the permissions
      "echo '${file(var.front-key)}' > /home/ubuntu/terraform-front-key.pem",
      "chmod 400 /home/ubuntu/terraform-front-key.pem" ,

      # Create the file and set the permissions
      "echo '${file(var.back-key)}' > /home/ubuntu/terraform-back-key.pem",
      "chmod 400 /home/ubuntu/terraform-back-key.pem" ,

      # Create the file and set the permissions
      "echo '${file(var.data-key)}' > /home/ubuntu/terraform-data-key.pem",
      "chmod 400 /home/ubuntu/terraform-data-key.pem" ,
      
      # Replace server_name with _default
        "sudo sed -i 's|server_name .*|server_name ${aws_lb.alb_front.dns_name};|' /etc/nginx/sites-available/fundoo.conf",
       "sudo sed -i 's|proxy_pass .*|proxy_pass http://${aws_lb.alb_back.dns_name}:8000;|' /etc/nginx/sites-available/fundoo.conf",

      # Restart or reload Nginx to apply the changes
      # Reload or restart Nginx to apply the changes
       "sudo systemctl daemon-reload",
       "sudo systemctl reload nginx"
    
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.front-key) # Path to private key for SSH connection
      host        = aws_instance.terraform_front_ec2.public_ip  # Public IP of the EC2 instance
      port        = var.port_22
      timeout     = "2m"
    }
     
  }
  tags = {
    Name = var.ws-front-ec2-name
  }
  depends_on = [ aws_lb.alb_front,aws_lb.alb_back ]
}





# Create a Security Group
resource "aws_security_group" "terraform_back_ec2_sg" {
  name        = "terraform-back-ec2-security-group"
  description = "Allow SSH "
  vpc_id      = aws_vpc.terraform_vpc.id
  

  # Allow SSH access
  ingress {
    from_port   = var.port_22
    to_port     = var.port_22
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic] 
  }

  # Allow HTTP access
  ingress {
    from_port   = var.port_8000
    to_port     = var.port_8000
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }
  ingress {
    from_port   = var.port_5432
    to_port     = var.port_5432
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }
  # Allow all outbound traffic
  egress {
    from_port   = var.port_0
    to_port     = var.port_0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }
  
  tags = {
    Name = var.ws-backend-sg-name
  }
}
# # Generate a private key locally
# resource "tls_private_key" "terraform2" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # Create the EC2 Key Pair with the generated public key
# resource "aws_key_pair" "ec2_key_pair_back" {
#   key_name   = "terraform-back-key"
#   public_key = tls_private_key.terraform2.public_key_openssh
# }

# # Save the private key to a file (optional)
# resource "local_file" "private_key_back" {
#   content  = tls_private_key.terraform2.private_key_pem
#   filename = "terraform-back-key.pem"
# }


resource "aws_security_group" "terraform_data_ec2_sg" {
  name        = "terraform-data-ec2-security-group"
  description = "Allow SSH and PostgreSQL access"
  vpc_id      = aws_vpc.terraform_vpc.id

  # Allow SSH access
  ingress {
    from_port   = var.port_22
    to_port     = var.port_22
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]  # Replace with your IP range for better security
  }

  # Allow PostgreSQL access
  ingress {
    from_port   = var.port_5432
    to_port     = var.port_5432
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]  # Replace with your IP range for better security
  }

  # Allow all outbound traffic
  egress {
    from_port   = var.port_0
    to_port     = var.port_0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name = var.ws-data-sg-name
  }
}
# # Generate a private key locally
# resource "tls_private_key" "terraform3" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # Create the EC2 Key Pair with the generated public key
# resource "aws_key_pair" "ec2_key_pair_data" {
#   key_name   = "terraform-data-key"
#   public_key = tls_private_key.terraform3.public_key_openssh
# }

# # Save the private key to a file (optional)
# resource "local_file" "private_key_data" {
#   content  = tls_private_key.terraform3.private_key_pem
#   filename = "terraform-data-key.pem"
# }

resource "aws_instance" "terraform_data_ec2" {
  ami                         = var.ws-data-ami
  instance_type               = var.ws-data-ec2-type
  key_name                    = var.ws-data-key-name
  subnet_id                   = aws_subnet.terraform_private_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.terraform_data_ec2_sg.id]
  associate_public_ip_address = false 
tags = {
    Name = var.ws-data-ec2-name
  }
}
resource "null_resource" "database_setup" {
  triggers = {
    instance_id=aws_instance.terraform_data_ec2.id
  }

   provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y postgresql postgresql-contrib",
      "sudo systemctl enable postgresql",
      "sudo systemctl start postgresql",
      "sudo -u postgres psql -c \"CREATE USER fundoo WITH PASSWORD 'root';\"",
      "sudo -u postgres psql -c \"CREATE DATABASE fundoodb OWNER fundoo;\"",
      "sudo sed -i \"s/#listen_addresses = 'localhost'/listen_addresses = '*'/g\" /etc/postgresql/16/main/postgresql.conf",
      "sudo bash -c 'echo \"host  all all 0.0.0.0/0 md5\" >> /etc/postgresql/*/main/pg_hba.conf'",
      "sudo systemctl restart postgresql"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.data-key)
      host        = aws_instance.terraform_data_ec2.private_ip  
      port        = var.port_22
      timeout     = "10m"
      bastion_host = aws_instance.terraform_front_ec2.public_ip
      bastion_private_key = file(var.front-key)
     
    }
  }
   depends_on = [aws_instance.terraform_data_ec2]

  
}

#create ec2
resource "aws_instance" "terraform_back_ec2" {
  ami               = var.ws-back-ami
  instance_type     = var.ws-back-ec2-type         
  key_name          = var.ws-back-key-name
  subnet_id     = aws_subnet.terraform_private_subnet_1.id 
  security_groups = [aws_security_group.terraform_back_ec2_sg.id] 
  
  associate_public_ip_address = false

   tags = {
    Name = var.ws-back-ec2-name
  }
}

resource "null_resource"  "backend_setup" {
  triggers = {
    instance_id = aws_instance.terraform_back_ec2.id
  }
  provisioner "remote-exec" {
    inline = [
      # Create the file and set the permissions
      "echo '${file(var.data-key)}' > /home/ubuntu/terraform-data-key.pem",
      "chmod 400 /home/ubuntu/terraform-data-key.pem" ,
      "echo 'Updating DATABASE_HOST IN env.confg'",

      "sudo sed -i 's/DATABASE_HOST=.*/DATABASE_HOST=${aws_instance.terraform_data_ec2.private_ip}/' /etc/env.confg",
      "sudo systemctl daemon-reload",
      "echo 'Update completed'",
      "echo 'migrating'",
      "sudo su ram bash -c 'cd /home/ram && source myenv/bin/activate && cd /FUNDOO-NOTES/fundoo_notes && python3 manage.py makemigrations && python3 manage.py migrate'",
      "sudo systemctl restart gunicorn.service" ,

    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.back-key)# Path to private key for SSH connection
      host        = aws_instance.terraform_back_ec2.private_ip  # Public IP of the EC2 instance
      bastion_host = aws_instance.terraform_front_ec2.public_ip
      bastion_private_key =file(var.front-key)
      port        = var.port_22
      timeout     = "10m"
    }
  }
   depends_on = [ aws_instance.terraform_back_ec2 ,
                  null_resource.database_setup]
  
 
}



#----------------------------------#
#----------------------------------#


# Application Load Balancer
resource "aws_lb" "alb_back" {
  name               = var.backend-alb-name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_back_ec2_sg.id]
  subnets            = [aws_subnet.terraform_private_subnet_1.id, aws_subnet.terraform_private_subnet_2.id]

 }

# Target Group
resource "aws_lb_target_group" "tg_back" {
  name     = var.tg-back-name
  port     = var.port_80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
    path                = "/home/"
    interval            = var.intervell
    timeout             = var.timeout
    healthy_threshold   = var.health_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

# Listener for HTTP
resource "aws_lb_listener" "http_listener_back" {
  load_balancer_arn = aws_lb.alb_back.arn
  port              = var.port_8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_back.arn
  }
}
resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.tg_back.arn
  target_id        = aws_instance.terraform_back_ec2.id
  port             = 8000 
}

# #-------------#

# Application Load Balancer
resource "aws_lb" "alb_front" {
  name               = var.frontend-alb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_front_ec2_sg.id]
  subnets            = [aws_subnet.terraform_public_subnet_1.id, aws_subnet.terraform_public_subnet_2.id]

 }

# Target Group
resource "aws_lb_target_group" "tg_front" {
  name     = var.tg-front-name
  port     = var.port_80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
    protocol = "HTTP"
    path                = "/home/"
    interval            = var.intervell
    timeout             = var.timeout
    healthy_threshold   = var.health_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}


# Listener for HTTPS 
resource "aws_lb_listener" "https_listeners" {
  load_balancer_arn = aws_lb.alb_front.arn
  port              = var.port_80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_front.arn
  }
}
resource "aws_lb_target_group_attachment" "frontend_attachment" {
  target_group_arn = aws_lb_target_group.tg_front.arn
  target_id        = aws_instance.terraform_front_ec2.id
  port             = var.port_80
}


# #---------load balancer complete-------#






  
