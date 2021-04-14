resource "aws_security_group" "web_elb_sg" {
  name        = "web_elb_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_demo_app.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
egress {
  description = "TLS from VPC"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

}