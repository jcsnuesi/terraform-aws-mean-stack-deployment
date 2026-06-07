resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "mean-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id
  tags = {
    Name = "mean-nat-gateway"
  }
  depends_on = [aws_eip.nat_eip]
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "mean-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private_rt.id
}
