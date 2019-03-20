data "aws_iam_policy_document" "plan_exe_lab_worker_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "autoscaling.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "plan_exe_lab_proxy_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "plan_exe_lab_proxy_role_policy_real" {
  depends_on = ["aws_iam_role.plan_exe_lab_proxy_role"]
  name = "plan_exe_lab_proxy_role_policy_real"
  role = "${aws_iam_role.plan_exe_lab_proxy_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "elasticloadbalancing:DeleteLoadBalancerListeners",
        "elasticloadbalancing:ConfigureHealthCheck",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeLoadBalancers"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "plan_exe_lab_worker_instance_profile" {
  name = "plan_exe_lab_worker_instance_profile"
  path = "/"
  role = "${aws_iam_role.plan_exe_lab_worker_role.name}"
}

resource "aws_iam_role" "plan_exe_lab_worker_role" {
  name               = "plan_exe_lab_worker_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.plan_exe_lab_worker_role_policy.json}"
  tags = {
    Name = "Worker IAM Role"
  }
}

resource "aws_iam_role" "plan_exe_lab_proxy_role" {
  name               = "plan_exe_lab_proxy_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.plan_exe_lab_proxy_role_policy.json}"
  tags = {
    Name = "Proxy IAM Role"
  }
}