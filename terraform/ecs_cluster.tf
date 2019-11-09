resource "aws_ecs_cluster" "geocache" {
  name = "geocache"

  tags = {
    Name = "geocache"
  }
}

# AutoScalingでのEC2起動設定
resource "aws_launch_configuration" "geocache" {
  name_prefix = "geo_cash_cluster_instance"
  image_id = local.ecs_optimized_ami # どのamiか設定
  instance_type = local.ecs_instance_type # インスタンスタイプの設定
  security_groups = [aws_security_group.geocache_cluster_instance.id] # セキュリティグループの設定
  iam_instance_profile = aws_iam_instance_profile.geocache_cluster_instance.name # インスタンスのプロフィール設定
  enable_monitoring = true # 監視状態
  user_data = <<EOF
    #!/bin/bash
    echo 'ECS_CLUSTER=geocache' >> etc/ecs/ecs.config
  EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "geocache" {
  name = "geocache_cluster_instance"
  max_size = "2"
  min_size = "2"
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = "2"
  force_delete = true
  launch_configuration = aws_launch_configuration.geocache.name
  vpc_zone_identifier = aws_subnet.geocache_private_subnets[*].id # どのネットワークに配置するか
  tag {
    key = "Name"
    value = "geocache_cluster_instance"
    propagate_at_launch = true
  }
}