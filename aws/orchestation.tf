#The queues are used as part of the upgrade process:
#When AWS replaces an instance, the instance can learn of its impending doom and gracefully exit itself from the swarm
#and manager quorum.
# SQS is used to notify a node that is going down.
#Los nodos revisan cada cierto tiempo las colas para ver si hay que actualizar el cluster
resource "aws_sqs_queue" "swarm_sqs_queue" {
  name                      = "swarm-sqs-queue"
  message_retention_seconds = 43200
  receive_wait_time_seconds = 10

  tags = {
    Name = "Swarm SQS Queue"
  }
}