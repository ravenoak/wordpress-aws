resource "aws_ecr_repository" "reverse_proxy" {
  name = "wordpress-service/reverse-proxy"
}

resource "aws_vpc_endpoint" "ecr_dkr_az1" {
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_id       = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.wordpress_1, aws_subnet.reverse_proxy_1]
}

resource "aws_vpc_endpoint" "ecr_api_az1" {
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_id       = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.wordpress_1, aws_subnet.reverse_proxy_1]
}

resource "aws_vpc_endpoint" "ecr_dkr_az2" {
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_id       = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.wordpress_2, aws_subnet.reverse_proxy_2]
}

resource "aws_vpc_endpoint" "ecr_api_az2" {
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_id       = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.wordpress_2, aws_subnet.reverse_proxy_2]
}
