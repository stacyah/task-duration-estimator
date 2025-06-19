# main.tf
# this file defines all the aws resources needed to host my task estimator app.

# define the aws provider and specify the cloud region
provider "aws" {
  region = "us-east-1"
}

# this data block automatically finds the latest ubuntu 22.04 ami for us.
# this is better than hardcoding an ami id that can change.
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # this is the official aws account id for canonical (ubuntu's owner)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# upload my public ssh key to aws so i can connect to the server.
# this matches the private key stored on my local machine.
resource "aws_key_pair" "my_key" {
  key_name   = "task-estimator-key"
  public_key = file("~/.ssh/task-estimator-key.pub")
}

# my application's firewall rules.
# this security group controls what traffic can reach the server.
resource "aws_security_group" "task_estimator_firewall" {
  name        = "stacy-task-estimator-sg" # a unique name for the security group in aws
  description = "firewall for the task estimator application"

  # allow ssh connections (port 22) from anywhere so i can manage the server
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow app traffic (port 5000) from anywhere for my flask app
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound traffic so the server can download updates and clone git repos
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this resource defines the ec2 virtual machine itself.
resource "aws_instance" "task_estimator_vm" {
  # using a standard ubuntu 22.04 image. it's free-tier eligible.
  ami = data.aws_ami.latest_ubuntu.id

  # t2.micro is the instance size. also free-tier eligible.
  instance_type = "t2.micro"

  # attach the firewall rules (security group) we defined above
  vpc_security_group_ids = [aws_security_group.task_estimator_firewall.id]
  
  # reference the ssh key we need to log in
  key_name = "task-estimator-key"

  # tags help me identify my resources in the aws console.
  tags = {
    Name    = "stacy-task-estimator-vm"
    Project = "Task Duration Estimator"
    Owner   = "Stacy Hilliard"
  }
}

# after the server is created, output its public ip address to my terminal.
output "instance_public_ip" {
  description = "the public ip address for my task estimator server"
  value       = aws_instance.task_estimator_vm.public_ip
}