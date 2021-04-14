

resource "aws_subnet" "app-private" {
  count             = "${length(slice(local.az_name, 0, 2))}"
  vpc_id            = aws_vpc.my_demo_app.id
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_name))}"
  availability_zone = "${local.az_name[count.index]}"

  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}
