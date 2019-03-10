resource "aws_cloudwatch_log_group" "planExeLab_log_group" {
  name = "PlanExeLab_Log_Group"
  retention_in_days = 7
  tags = {
    Name = "Plan Exe Lab Log Group"
  }
}