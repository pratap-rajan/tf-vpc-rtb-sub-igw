locals {

  az_name     = "${data.aws_availability_zones.azs.names}"
  pub_sub_ids = "${aws_subnet.app-public.*.id}"

}

resource "aws_subnet" "app-public" {
  count             = "${length(local.az_name)}"
  vpc_id            = aws_vpc.my_demo_app.id
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index)}" 
  availability_zone = "${local.az_name[count.index]}"
  #Make True to assign public IP
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}
# Internet Gateway for Public Access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_demo_app.id

  tags = {
    Name = "App-Internet-Gateway"
  }
}

# Creation of Route Table
resource "aws_route_table" "pub-rtb" {
  vpc_id = aws_vpc.my_demo_app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "App-Public-Route-Table"
  }
}

# Subnet Association to Route Table
resource "aws_route_table_association" "rtb-sub-assoc" {
  count = "${length(local.az_name)}"
  # Gets all the subnet from the previous step. * -> All IDs and then loop using count index
  subnet_id      = "${local.pub_sub_ids[count.index]}"
  route_table_id = aws_route_table.pub-rtb.id
}
