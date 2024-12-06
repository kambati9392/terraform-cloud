variable "vpc_cidr_block" {
  description = "vpc cidr block"
}
variable "terraform_vpc_name" {
  description = "terraform vpc name"
}
variable "igw-name" {
  description = "internet gateway name"
}
#-------#

variable "public_subnet_cidr_1" {
  description = "cidr block of public subnet 1"
}
variable "public_subnet_az_1" {
  description = "availability zone for public subnet 1"
}
variable "public_subnet_1_name" {
  description = "public subnet 1 name"
}
variable "public_subnet_cidr_2" {
  description = "cidr block of public subnet 2"
}
variable "public_subnet_az_2" {
  description = "availability zone for public subnet 2"
}
variable "public_subnet_2_name" {
  description = "public subnet 2 name"
}
variable "private_subnet_cidr_1" {
  description = "cidr block of privatec subnet 1"
}
variable "private_subnet_az_1" {
  description = "availability zone for private subnet 1"
}
variable "private_subnet_1_name" {
  description = "private subnet 1 name"
}
variable "private_subnet_cidr_2" {
  description = "cidr block of privatec subnet 2"
}
variable "private_subnet_az_2" {
  description = "availability zone for private subnet 2"
}
variable "private_subnet_2_name" {
  description = "private subnet 2 name"
}
#----#
variable "all_traffic" {
  description = "allow all traffic"
}
variable "ws-pub-route-table" {
  description = "name of public route table"
}
variable "ws-pri-route-tabled" {
  description = "name of the private route table"
}

variable "ws-nat-gate-way" {
  description = "name of the nat-gateway"
}

#----------------------#
#-------------ec2-----------------------#
variable "front-key" {
  description = "value"
}
variable "back-key" {
  description = "value"
}
variable "data-key" {
  description = "value"
}
variable "ws-front-sg-name" {
  description = "security group for frontend ec2"
}
variable "port_22" {
  description = "value of port"
}
variable "port_80" {
  description = "value of port"
}
variable "port_0" {
  description = "value of port"
}
 variable "ws-front-key-name" {
  description = "frontend key"
  }
variable "ws-front-ami" {
  description = "frontend ami"
}
variable "ws-front-ec2-type" {
  description = "instances type"
}
variable "ws-front-ec2-name" {
  description = "frontend ec2 name"
}
#---#
variable "port_8000" {
  description = "values of port"
}
variable "port_5432" {
  description = "values of port"
}
variable "ws-backend-sg-name" {
  description = "security group for frontend ec2"
}
 variable "ws-back-key-name" {
   description = "backend key pair name"
 }
variable "ws-back-ami" {
  description = "backend ami"
}
variable "ws-back-ec2-type" {
  description = "backend ec2 type"
}
variable "ws-back-ec2-name" {
  description = "name of backend ec2"
}
#-----#

variable "ws-data-sg-name" {
  description = "data sg name"
}
 variable "ws-data-key-name" {
   description = "database key name"
 }
variable "ws-data-ami" {
  description = "database ami"
}
variable "ws-data-ec2-type" {
  description = "ec2 type"
}
variable "ws-data-ec2-name" {
  description = "name of ec2"
}

#--------------#
#----alb--------#
variable "backend-alb-name" {
  description = "value"
}
variable "intervell" {
  description = "intervell values"
}
variable "timeout" {
  description = "timeout value"
}
variable "unhealthy_threshold" {
  description = "unhealthy threshold values"
}
variable "health_threshold" {
  description = "health threshold values"
}
variable "health_check_back_path" {
  description = "path for health chcek"
}
variable "port_back_alb" {
  description = "port value for backend alb"
}
variable "tg-back-name" {
  description = "name of backend target group"
}
#---#
variable "health_chcek_front_path" {
  description = "value"
}
variable "frontend-alb-name" {
  description = "value"
}
variable "tg-front-name" {
  description = "name of backend target group"
}

# #-------#
# variable "back-lt-name" {
#   description = "launch template name"
# }
# variable "back-scalingpolicy-name" {
#   description = "value"
# }






# variable "back_desired" {
#   description = "value"
# }
# variable "back_max" {
#   description = "value"
# }
# variable "back_min" {
#   description = "value"
# }
# variable "back_health_chcek_grace_period" {
#   description = "value"
# }
# variable "back-asg-name" {
#   description = "value"
# }
# variable "back-target-values" {
#   description = "value"
# }
# #----#
# variable "ws-front-desired" {
#   description = "value"
# }
# variable "ws-front-max" {
#   description = "value"
# }
# variable "ws-front-min" {
#   description = "value"
# }
# variable "front-asg-name" {
#   description = "value"
# }
# variable "front-health-chcek-period" {
#   description = "value"
# }
# variable "front-target-values" {
#   description = "value"
# }




# #------#
# variable "front-tg-resource-name"{
#   description="value"
# }
# variable "back-tg-resource-name"{
#   description="value"
# }
