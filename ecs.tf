resource "aws_ecs_capacity_provider" "ecs-cp" {
  name = "terraform-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
    name  = "ecs"
}

resource "aws_ecs_cluster_capacity_providers" "ecs-cluster-cp" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs-cp.name]
}

resource "aws_ecs_task_definition" "ecs-nginx-task" {
  family = "nginx-task"
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx"
      cpu       = 10
      memory    = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ]) 
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs-nginx-task.arn
  desired_count   = 1
}