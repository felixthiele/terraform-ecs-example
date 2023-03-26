resource "aws_launch_configuration" "ecs_launch_config" {
    // To find correct AMI: aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended
    image_id             = "ami-0045f08b64385f54c"
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data            = filebase64("user_data.sh")
    instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "asg"
    vpc_zone_identifier       = [aws_subnet.pub_subnet.id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 0
    max_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
}