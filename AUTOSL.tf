# AUTOSCALING GROUP STEPS 
# PLACEMENT GROUP(aws_placement_group)

resource "aws_placement_group" "PROJECT9-plg1" {
  name     = "project9-plg"
  strategy = "partition"
}

# launch_configuration

resource "aws_launch_configuration" "PROJECT9-ltp" {
  name_prefix   = "launch_template"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = "ec2-key"
  security_groups = [aws_security_group.PROJECT9-vpc-security-group.id, aws_security_group.project9-DB-secgrp.id]
  associate_public_ip_address = true
  user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet addr:172)' | awk '{ print $2 }' | cut -d ':' -f 2` echo 'Hello Team This is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
      create_before_destroy = true
  }
}

# aws_autoscaling_group

resource "aws_autoscaling_group" "PROJECT9-auto" {
  name                      = "project9-asg"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  placement_group           = aws_placement_group.PROJECT9-plg1.id
  launch_configuration      = aws_launch_configuration.PROJECT9-ltp.name
  vpc_zone_identifier       = [aws_subnet.project9-pubsubnet1.id, aws_subnet.project9-pubsubnet2.id]
  target_group_arns         = [aws_alb_target_group.PROJECT9_alb_target_group.arn]

  lifecycle {
      create_before_destroy = true
  }

  tag {
    key                 = "name"
    value               = "true"
    propagate_at_launch = true
  }

}

# AUTOSCALING POLICY

resource "aws_autoscaling_policy" "prj9_cpu_up" {
  name                   = "prj9-cpu-policy-up"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.PROJECT9-auto.name
}

resource "aws_autoscaling_policy" "prj_cpu_down" {
  name                   = "prj9-cpu-policy-down"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.PROJECT9-auto.name
}

# CLOUD WATCH MONITORING

resource "aws_cloudwatch_metric_alarm" "prj9-cpu-alarm" {
  alarm_name                = "prj9-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"

    dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.PROJECT9-auto.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.prj9_cpu_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "prj9-cpu-alarm_down" {
  alarm_name                = "prj9-cpu-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"

    dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.PROJECT9-auto.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.prj_cpu_down.arn]
}
