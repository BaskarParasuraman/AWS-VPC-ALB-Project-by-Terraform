resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "rtba1" {
  route_table_id = aws_route_table.rtb.id
  subnet_id = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "rtba2" {
  route_table_id = aws_route_table.rtb.id
  subnet_id = aws_subnet.subnet2.id
}

resource "aws_security_group" "mysg" {
  name = "mysg"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucketbasssho"
}

resource "aws_instance" "myins1" {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.subnet1.id
  user_data = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "myins2" {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.subnet2.id
  user_data = base64encode(file("userdata2.sh"))
}

resource "aws_lb" "loadbalancer" {
  name = "loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {
    name = "Web-server-LB"
  }
}

resource "aws_lb_target_group" "lbtg" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "tgattach1" {
  target_group_arn = aws_lb_target_group.lbtg.arn
  target_id = aws_instance.myins1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "tgattach2" {
  target_group_arn = aws_lb_target_group.lbtg.arn
  target_id = aws_instance.myins2.id
  port = 80
}

resource "aws_lb_listener" "lblistener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbtg.arn
  }
}

output "loadbalancerdns" {
  value = aws_lb.loadbalancer.dns_name
}