vpc_cidr_block = "10.0.0.0/16"

terraform_vpc_name = "test_vpc"

igw-name = "ws-test-igw"

public_subnet_cidr_1 = "10.0.0.0/18"
public_subnet_az_1 = "ap-southeaast-1a"
public_subnet_1_name = "ws-test-pubsub-1"

public_subnet_cidr_2 = "10.0.64.0/18"
public_subnet_az_2 = "ap-southeast-1b"
public_subnet_2_name = "ws-test-pubsub-2"

private_subnet_cidr_1 = "10.0.128.0/18"
private_subnet_az_1 = "ap-south-1a"
private_subnet_1_name = "ws-test-prisub-1"

private_subnet_cidr_2 = "10.0.192.0/18"
private_subnet_az_2 = "ap-southeast-1b"
private_subnet_2_name = "ws-test-prisub-2"

all_traffic = "0.0.0.0/0"
ws-pub-route-table = "ws-test-pub-route-table"
ws-pri-route-tabled = "ws-test-pri-route-table"

ws-nat-gate-way="ws-test-natgateway"

ws-front-sg-name = "ws-test-front-sg"
port_0 = "0"
port_22 = "22"
port_5432 = "5432"
port_80 = "80"
port_8000 = "8000"
#ws-frontend-key-name = "ws_test_front_key"
back-key = "C:/Users/manoj/Desktop/state-s3-bucket/remote/terraform-back-key.pem"
data-key = "C:/Users/manoj/Desktop/state-s3-bucket/remote/terraform-data-key.pem"
front-key ="C:/Users/manoj/Desktop/state-s3-bucket/remote/terraform-front-key.pem"
ws-front-ami = "ami-086d43eef3881acfd"
ws-front-ec2-type = "t2.micro"
ws-front-ec2-name = "ws-test-front-ec2"
ws-backend-sg-name = "ws-test-back-sg"
ws-back-key-name = "ws-test-back-key"
ws-back-ami = "ami-0f3c24f6c76c4df44"
ws-back-ec2-type = "t2.micro"
ws-back-ec2-name = "ws-test-back-ec2"
ws-data-sg-name = "ws-test-data-sg"
ws-data-key-name = "ws-test-data-key"
ws-data-ami = "ami-047126e50991d067b"
ws-data-ec2-type = "t2.micro"
ws-data-ec2-name = "ws-test-data-ec2"

backend-alb-name = "ws-dev-alb-back-alb"
intervell = "30"
timeout = "5"
unhealthy_threshold = "2"
health_threshold = "3"
health_check_back_path = "/home/"
port_back_alb = "8000"
tg-back-name = "ws-test-back-tg"
health_chcek_front_path = "/home/"
frontend-alb-name = "ws-dev-front-alb"
tg-front-name = "ws-test-front-tg"


# #---#
# back-lt-name="dev-ws-back-lt"
# back-scalingpolicy-name="dev-ws-back-asp"
# back_desired = "2"
# back_max = "3"
# back_min = "1"
# back_health_chcek_grace_period = "300"
# back-asg-name = "dev-ws-back-asg"
# back-target-values = 50

# ws-front-desired = "2"
# ws-front-max = "3"
# ws-front-min = "1"
# front-asg-name = "dev-ws-front-asg"
# front-health-chcek-period = "300"
# front-target-values = "50"

# #-----#
