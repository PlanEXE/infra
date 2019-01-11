resource "null_resource" "create_cluster" {
	provisioner "local-exec" {
		command = "docker swarm init"
	}
}

resource "null_resource" "show_nodes" {
	depends_on = ["null_resource.create_cluster"]
	provisioner "local-exec" {
		command = "docker node ls"
	}	
}