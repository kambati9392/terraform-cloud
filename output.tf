output "vpc_id"{
  value = aws_vpc.terraform_vpc.id
}
output "igw-id" {
  value = aws_internet_gateway.terraform_igw.id
}

output "pub-sub-1-id" {
  value = aws_subnet.terraform_public_subnet_1.id
}
output "pub-sub-2-id" {
  value = aws_subnet.terraform_public_subnet_2.id
}
output "pri-sub-1-id" {
  value = aws_subnet.terraform_private_subnet_1.id
}
output "pri-sub-2-id" {
  value = aws_subnet.terraform_private_subnet_2.id
}
output "pub-route-table-id" {
  value = aws_route_table.terraform_public_route_table.id
}
output "pri-route-table-id" {
  value = aws_route_table.terraform_private_route_table.id
}
output "natgateway" {
  value = aws_nat_gateway.nat_gateway.id
}
output "front-ec2-id" {
  value = aws_instance.terraform_front_ec2.id
}
output "backend-ec2-id" {
  value = aws_instance.terraform_back_ec2.id
}
output "database-ec2-id" {
  value = aws_instance.terraform_data_ec2.id
  
}
output "backend-load_balancer_dns" {
  value = aws_lb.alb_back.dns_name

}
output "frontend-load_balancer_dns" {
  value = aws_lb.alb_front.dns_name
}
