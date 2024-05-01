locals {
    tags = {
        Project = var.project
    }
}

data "aws_iam_role" "task_execution" {
    name = "ecsTaskExecutionRole"
}

resource "aws_lb_target_group" "main" {
    name = "${var.name}-tg"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id
}

resource "aws_lb_listener" "main" {
    load_balancer_arn = var.alb_arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.main.arn
    }
}

resource "aws_ecs_task_definition" "main" {
    family = var.name
    execution_role_arn = data.aws_iam_role.task_execution.arn
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 1024
    memory = 2048
    container_definitions = jsonencode([{
        name = var.name
        image = var.image
        essential = true
        portMappings = [{
            containerPort = 80
            hostPort = 80
        }]
    }])

    tags = local.tags
}

resource "aws_ecs_service" "main" {
    name = var.name
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.main.arn
    desired_count = 1
    network_configuration {
      subnets = var.subnet_ids
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.main.arn
        container_name = var.name
        container_port = 80
    }
    force_new_deployment = true
    triggers = {
        redeployment = timestamp()
    }
}