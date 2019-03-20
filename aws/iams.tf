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

resource "aws_iam_role_policy" "plan_exe_lab_proxy_role_policy_elb" {
  depends_on = ["aws_iam_role.plan_exe_lab_proxy_role"]
  name = "plan_exe_lab_proxy_role_policy_updates"
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

resource "aws_iam_role_policy" "plan_exe_lab_proxy_ecr_policy" {
  depends_on = ["aws_iam_role.plan_exe_lab_proxy_role", "aws_iam_role.plan_exe_lab_worker_role"]
  name = "plan_exe_lab_ecr_policy"
  role = "${aws_iam_role.plan_exe_lab_proxy_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

// Politicas para dar permisos a ECR (Elastic Container Regitry) para manejar imagenes
resource "aws_iam_role_policy" "plan_exe_lab_worker_ecr_policy" {
  depends_on = ["aws_iam_role.plan_exe_lab_proxy_role", "aws_iam_role.plan_exe_lab_worker_role"]
  name = "plan_exe_lab_ecr_policy"
  role = "${aws_iam_role.plan_exe_lab_worker_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "plan_exe_lab_swarm_api_policy" {
  depends_on = ["aws_iam_role.plan_exe_lab_proxy_role"]
  name = "plan_exe_lab_swarm_api_policy"
  role = "${aws_iam_role.plan_exe_lab_proxy_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVpcAttribute"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}