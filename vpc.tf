locals {
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
}

## VPC
resource "aws_vpc" "geocache" {
  cidr_block = "192.168.51.0/24"

  tags = {
    Name = "geocache"
  }

  enable_dns_support = true
  enable_dns_hostnames = true
}