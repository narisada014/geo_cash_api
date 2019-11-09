resource "aws_ecs_task_definition" "geocache" {
  family = "geocache"
  network_mode = "bridge"
  container_definitions = <<EOS
  [
    {
      "name": "geocache",
      "image": "${local.acnt_id}.dkr.ecr.ap-northeast-1.amazonaws.com/geocache:latest",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": 3000
        }
      ]
    }
  ]
  EOS
}