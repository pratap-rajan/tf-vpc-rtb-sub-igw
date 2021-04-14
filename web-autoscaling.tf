resource "aws_launch_configuration" "web_asg_lc" {
  name_prefix          = "terraform-lc-example-"
  image_id             = "${var.web-server-ami[var.region]}"
  instance_type        = "t3.micro"
  user_data            = "${file("scripts/apache.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.s3_ec2_profile.name}"
  security_groups      = ["${aws_security_group.web_sg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "terraform-asg-example"
  launch_configuration      = aws_launch_configuration.web_asg_lc.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 30
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.web-elb.name]
  vpc_zone_identifier       = "${local.pub_sub_ids}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "AddInstance" {
  name                   = "AddInstance"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "RemoveInstance" {
  name                   = "RemoveInstance"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_greater_70" {
  alarm_name          = "terraform-test-avg-cpu-grt-70"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization > 70%"
  alarm_actions     = [aws_autoscaling_policy.AddInstance.arn]
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_lesser_20" {
  alarm_name          = "terraform-test-avg-cpu-less-20"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization > 70%"
  alarm_actions     = [aws_autoscaling_policy.RemoveInstance.arn]
}
