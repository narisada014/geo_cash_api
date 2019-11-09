locals {
  plcy = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# IAMロール作成
resource "aws_iam_role" "geocache_cluster_instance" {
  name = "geocache_cluster_instance"
  path = "/"
  # ロールにつくポリシー
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

# IAMにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "geocache_cluster_instance" {
  role = aws_iam_role.geocache_cluster_instance.name
  policy_arn = local.plcy
}

# IAMから作成されたインスタンスにprofileをつける
resource "aws_iam_instance_profile" "geocache_cluster_instance" {
  name = "geocache_cluster_instance"
  role = aws_iam_role.geocache_cluster_instance.name
}

# ロールにつくポリシーの具体的な内容
data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}