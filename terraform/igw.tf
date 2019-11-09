## インターネットゲートウェイ
resource "aws_internet_gateway" "geocache_public" {
  vpc_id = aws_vpc.geocache.id

  tags = {
    Name = "geocache_public_igw"
  }
}