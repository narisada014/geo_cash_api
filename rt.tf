# パブリックサブネットのルーティング設定
resource "aws_route_table" "geocache_public" {
  vpc_id = aws_vpc.geocache.id

  route {
    cidr_block = "0.0.0.0/0" # デフォルトのゲートウェイ
    gateway_id = aws_internet_gateway.geocache_public.id # IGWを作成したIGWに設定
  }

  tags = {
    Name = "geocache_public_rt"
  }
}

# ルートテーブルのみ用意しておく。インターネットには接続しない
resource "aws_route_table" "geocache_private" {
  vpc_id = aws_vpc.geocache.id

  tags = {
    Name = "geocache_private_rt"
  }
}

# ルーティングテーブルをパブリックサブネットに紐付ける設定
resource "aws_route_table_association" "geocache_public" {
  count = length(local.availability_zones)
  subnet_id = element(aws_subnet.geocache_public_subnets[*].id, count.index)
  route_table_id = aws_route_table.geocache_public.id
}

# ルーティングテーブルをプライベートサブネットに紐づける設定
# VPCエンドポイントに紐づける為に作成しておく
resource "aws_route_table_association" "geocache_private" {
  route_table_id = aws_route_table.geocache_private.id
  subnet_id = element(aws_subnet.geocache_private_subnets[*].id, count.index)
  count = length(local.availability_zones)
}