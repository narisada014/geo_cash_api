# PrivateLinkにアタッチするセキュリティグループ
resource "aws_security_group" "geocache_privatelink" {
  name = "geocache_privatelink"
  description = "geocache_privatelink"
  vpc_id = aws_vpc.geocache.id
}

resource "aws_security_group_rule" "geocache_privatelink_ingress_https" {
  security_group_id = aws_security_group.geocache_privatelink.id
  source_security_group_id = aws_security_group.geocache_cluster_instance.id
  description = "geocache_privatelink"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  type = "ingress"
}

# クラスタインスタンスにアタッチするセキュリティグループ
resource "aws_security_group" "geocache_cluster_instance" {
  name = "geocache_cluster_instance"
  description = "geocache_cluster_instance"
  vpc_id = aws_vpc.geocache.id
}

# 443でのアウトバウンドの許可
resource "aws_security_group_rule" "geocache_cluster_instance_egress_https" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.geocache_cluster_instance.id
  to_port = 443
  type = "egress"
}

resource "aws_security_group_rule" "geocache_cluster_instance_ingress_from_geocache_alb" {
  security_group_id = aws_security_group.geocache_cluster_instance.id
  source_security_group_id = aws_security_group.geocache_alb.id
  from_port = 32768
  to_port = 65535
  protocol = "tcp"
  type = "ingress"
}

## 以下ALBの設定
resource "aws_security_group" "geocache_alb" {
  name = "geocache_alb"
  description = "geocache_alb"
  vpc_id = aws_vpc.geocache.id
}

# HTTPで受ける（外からのリクエストの設定）
resource "aws_security_group_rule" "geocache_alb_ingress_http_to_cluster_instance" {
  cidr_blocks = ["126.74.158.208/28"]
  description = "geocache_alb_ingress_https_to_geocache_cluster_instance"
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.geocache_alb.id
  to_port = 80
  type = "ingress"
}

# 中から外へ通信が出て行く時の設定
resource "aws_security_group_rule" "geocache_alb_egress_to_geocache_cluster_instance" {
  security_group_id = aws_security_group.geocache_alb.id
  source_security_group_id = aws_security_group.geocache_cluster_instance.id
  from_port = 32768
  to_port = 65535
  protocol = "tcp"
  type = "egress"
}