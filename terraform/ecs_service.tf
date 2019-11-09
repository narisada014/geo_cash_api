resource "aws_ecs_service" "geocache" {
  name = "geocache"
  cluster = aws_ecs_cluster.geocache.id
  launch_type = "EC2"

  desired_count = "2"
  health_check_grace_period_seconds = "15"
  task_definition = "${aws_ecs_task_definition.geocache.family}:${aws_ecs_task_definition.geocache.revision}"

  load_balancer {
    target_group_arn = aws_lb_target_group.geocache.arn
    container_name = "geocache"
    container_port = "3000"
  }

  ordered_placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type = "spread"
    field = "instanceId"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name = "geocache"
  }

  depends_on = [aws_lb_listener.geocache_alb_http]
}