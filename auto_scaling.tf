# Launch Template für die EC2-Instanzen in der Auto Scaling Group
resource "aws_launch_template" "web_server" {
  name_prefix   = "web-server-launch-template"
  image_id      = "ami-0084a47cc718c111a"  # Überprüfe, ob diese AMI-ID in der Region verfügbar ist
  instance_type = "t2.small"
  key_name      = "NEW"  # Dein SSH Key-Paar
 # user_data     = file("init.sh")  # Dein Initialisierungsskript
  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.asg.id]  # Sicherheitsgruppen
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group für die EC2-Instanzen
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.main_a.id, aws_subnet.main_b.id]  # Verwende beide Subnetze in verschiedenen AZs
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"  # Verwende die neueste Version des Launch Templates
  }

  health_check_type          = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout  = "0"
  target_group_arns         = [aws_lb_target_group.main.arn]

  
}
