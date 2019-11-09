## プライベートサブネット
resource "aws_subnet" "geocache_private_subnets" {
  vpc_id = aws_vpc.geocache.id
  count = length(local.availability_zones) # AZの数だけサブネットを展開

  # NOTE: ["192.168.51.0/26", "192.168.51.64/26"]
  cidr_block = cidrsubnet(aws_vpc.geocache.cidr_block, 2, 0 + count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags =  {
    Name = "geocache_private_subnets"
  }
}

# パブリックサブネット
resource "aws_subnet" "geocache_public_subnets" {
  vpc_id = aws_vpc.geocache.id
  count = length(local.availability_zones)

  # NOTE: ["192.168.51.128/26", "192.169.51.192/26"]
  cidr_block = cidrsubnet(aws_vpc.geocache.cidr_block, 2, 2 + count.index)
  availability_zone = element(local.availability_zones, count.index)
  tags = {
    Name = "geocache_public_subnets"
  }
}