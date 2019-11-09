resource "aws_vpc_endpoint" "geocache_ecr_api" {
  service_name = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"
  vpc_id = aws_vpc.geocache.id
  subnet_ids = aws_subnet.geocache_private_subnets[*].id

  # プライベートリンク用のセキュリティID
  security_group_ids = [
    aws_security_group.geocache_privatelink.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "geocache_ecr_dkr" {
  service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  vpc_id = aws_vpc.geocache.id
  subnet_ids = aws_subnet.geocache_private_subnets[*].id

  # プライベートリンク用のセキュリティID
  security_group_ids = [
    aws_security_group.geocache_privatelink.id
  ]

  private_dns_enabled = true
}
