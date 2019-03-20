resource "aws_cloudwatch_log_group" "plan_exe_lab_log_group" {
  name = "plan_exe_lab_log_group"
  retention_in_days = 7
  tags = {
    Name = "Plan Exe Lab Log Group"
  }
}