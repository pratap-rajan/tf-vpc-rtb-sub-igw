# Create a new load balancer
resource "aws_elb" "web-elb" {
  name = "web-elb-${terraform.workspace}"
  #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  subnets         = "${local.pub_sub_ids}"
  security_groups = ["${aws_security_group.web_elb_sg.id}"]
  /*  
  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }
*/
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
    #ssl_certificate_id = "${var.acm-cert}"
  }
  /*
  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.acm-cert}"
  }
*/
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  instances                   = "${aws_instance.web.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb-${terraform.workspace}"
  }
}
