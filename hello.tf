resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    command = "mkdir dir"
  }
}