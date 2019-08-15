variable "ami" {}
variable "instance_type" {}
variable "identity" {}
variable "key_name" {}
variable "resource_name" {}
variable "ssh_key_location" {}
variable "ssh_user" {}


resource "aws_instance" "k8s" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  tags = {
    "Identity" = "${var.identity}"
    "env"      = "test"
    "Name"     = "${var.resource_name}"
  }

}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '${var.ssh_user}' --private-key '${var.ssh_key_location}' -i '${aws_instance.k8s.public_dns},'  kube-dependencies.yml"
  }
  depends_on = [aws_instance.k8s]
}

output "public_ip" {
  value = "${aws_instance.k8s.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.k8s.*.public_dns}"
}