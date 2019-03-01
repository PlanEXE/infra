data "aws_iam_policy_document" "worker-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "worker_instance_profile" {
  name = "worker_instance_profile"
  path = "/"
  role = "${aws_iam_role.worker_role.name}"
}

resource "aws_iam_role" "worker_role" {
  name               = "worker_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.worker-role-policy.json}"
  tags = {
    Name = "Worker IAM Role"
  }
}