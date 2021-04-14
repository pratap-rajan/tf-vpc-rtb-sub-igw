resource "aws_db_instance" "tf-web-rds" {
  identifier           = "tf-web-rds-${terraform.workspace}"
  allocated_storage    = 20
  max_allocated_storage = 40
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "tfwebrds"
  username             = "rootadmin"
  password             = "Poilkjmnb!23"
  parameter_group_name = "default.mysql5.7"
  backup_window        = "01:00-02:00"
  db_subnet_group_name = "${aws_db_subnet_group.tf-web-rds.id}"
  auto_minor_version_upgrade = false
}

resource "aws_db_subnet_group" "tf-web-rds" {
  name       = "tf-web-db"
  subnet_ids = "${aws_subnet.app-private.*.id}"

  tags = {
    Name = "PrivateDBSubnet"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow TLS inbound to rds"
  vpc_id      = aws_vpc.my_demo_app.id

  ingress {
    description = "From EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = [aws_vpc.my_demo_app.cidr_block]
    security_groups = ["${aws_security_group.web_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
