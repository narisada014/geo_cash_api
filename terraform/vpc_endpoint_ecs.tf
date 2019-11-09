resource "aws_vpc_endpoint" "geocache_ecs-agent" {
  service_name = "com.amazonaws.ap-northeast-1.ecs-agent"
  vpc_endpoint_type = "Interface" # 直でAWSのAPIに接続するための仮装デバイス的な意味
  vpc_id = aws_vpc.geocache.id
  subnet_ids = aws_subnet.geocache_private_subnets[*].id

  security_group_ids = [
    aws_security_group.geocache_privatelink.id
  ]
  # プライベートホストゾーンを指定されたVPCに関連付けるかどうかを指定する
  # Interfaceタイプのエンドポイントに適用される。 デフォルトはfalse。
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "geocache_ecs-telemetry" {
  service_name = "com.amazonaws.ap-northeast-1.ecs-telemetry"
  vpc_endpoint_type = "Interface"
  vpc_id = aws_vpc.geocache.id
  subnet_ids = aws_subnet.geocache_private_subnets[*].id

  security_group_ids = [
    aws_security_group.geocache_privatelink.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "geocacheecs" {
  service_name = "com.amazonaws.ap-northeast-1.ecs"
  vpc_endpoint_type = "Interface"
  vpc_id = aws_vpc.geocache.id
  subnet_ids = aws_subnet.geocache_private_subnets[*].id

  security_group_ids = [
    aws_security_group.geocache_privatelink.id
  ]

  private_dns_enabled = true
}