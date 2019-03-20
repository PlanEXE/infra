#The queues are used as part of the upgrade process:
#When AWS replaces an instance, the instance can learn of its impending doom and gracefully exit itself from the swarm
#and manager quorum.
# SQS is used to notify a node that is going down.
#Los nodos revisan cada cierto tiempo las colas para ver si hay que actualizar el cluster
resource "aws_sqs_queue" "plan_exe_lab_swarm_sqs_queue" {
  name                      = "plan_exe_lab_swarm_sqs_queue"
  message_retention_seconds = 43200
  receive_wait_time_seconds = 10

  tags = {
    Name = "Plan Exe Lab Swarm SQS Queue"
  }
}

resource "aws_sqs_queue" "plan_exe_lab_swarm_sqs_queue_cleanup" {
  name                      = "plan_exe_lab_swarm_sqs_queue_cleanup"
  message_retention_seconds = 43200
  receive_wait_time_seconds = 10

  tags = {
    Name = "Plan Exe Lab Swarm SQS Queue Cleanup"
  }
}