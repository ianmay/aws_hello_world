# create a security group to allow inbound and outbound traffic
resource "aws_security_group" "hello_world_ec2_security_group" {
    name = "hello_world_ec2_security_group"
    # allow inbound on 80 (http)
    ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 80
      protocol = "tcp"
      to_port = 80
    }
    # allow inbound on 443 (https)
    ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 443
      protocol = "tcp"
      to_port = 443
    }
    # i could add ssh here if i intended to interact with the box
    
    # allow outbound everything for now
    egress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 0
      protocol = "-1"
      to_port = 0
    }
    
}

# create the instance
resource "aws_instance" "hello_world_ec2_instance" {
    ami = "ami-06bb074d1e196d0d4" # Amazon Linux 2 AMI
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.hello_world_ec2_security_group.id]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
# be nice to curl a file from the bucket at this point, but for now....
echo "<!doctype html><html><body><h1>hello mars</h1></body></html>" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = { 
      name = "hello_world_ec2_instance"
  }
}

# return the url for our instance
output "hello_world_instance_url" {
  value = aws_instance.hello_world_ec2_instance.public_dns
}