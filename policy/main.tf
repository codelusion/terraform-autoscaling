# Simple scaling auto scaling policy
#copied from https://github.com/unifio/terraform-aws-asg

## Creates simple scaling policy
resource "aws_autoscaling_policy" "asg_policy_simple" {
  adjustment_type        = "${var.adjustment_type}"
  autoscaling_group_name = "${var.asg_name}"
  cooldown               = "${var.cooldown}"
  name                   = "${var.policy_name}"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = "${var.scaling_adjustment}"
}

## Creates Simple Notification Service (SNS) topic
resource "aws_sns_topic" "sns_asg" {
  display_name = "${var.policy_name}-asg"
  name         = "${var.policy_name}-asg"
}

## Configures autoscaling notifications
resource "aws_autoscaling_notification" "asg_notify" {
  group_names   = ["${var.asg_name}"]
  notifications = ["${var.notifications}"]
  topic_arn     = "${aws_sns_topic.sns_asg.arn}"
}

## Creates CloudWatch monitor
resource "aws_cloudwatch_metric_alarm" "monitor_asg" {
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.asg_policy_simple.arn}"]
  alarm_description   = "${var.policy_name} ASG Monitor"
  alarm_name          = "${var.policy_name}-alarm"
  comparison_operator = "${var.comparison_operator}"

  dimensions = {
    "AutoScalingGroupName" = "${var.asg_name}"
  }

  evaluation_periods = "${var.evaluation_periods}"
  metric_name        = "${var.metric_name}"
  namespace          = "${var.name_space}"
  period             = "${var.period}"
  statistic          = "${lookup(var.valid_statistics, var.statistic)}"
  threshold          = "${var.threshold}"
}
