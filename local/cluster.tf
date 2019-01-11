resource "null_resource" "create_cluster" {
	provisioner "local-exec" {
		command = "docker swarm init"
	}
	provisioner "local-exec" {
		command = "docker node ls"
	}
	provisioner "local-exec" {
		command = "docker swarm leave -f"
		when = "destroy"
	}	
}