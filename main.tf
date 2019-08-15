variable "ami" {}
variable "instance_type" {}
variable "identity" {}
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "region" {
  default = "eu-west-1"
}
variable "ssh_key_location" {}
variable "ssh_user" {}
provider "aws" {
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"
  region     = "${var.region}"
}


module "server-1" {
  source           = "./server"
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  identity         = "${var.identity}"
  key_name         = "${var.key_name}"
  resource_name    = "k8s-worker1"
  ssh_user         = "${var.ssh_user}"
  ssh_key_location = "${var.ssh_key_location}"
}
module "server-2" {
  source           = "./server"
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  identity         = "${var.identity}"
  key_name         = "${var.key_name}"
  resource_name    = "k8s-worker2"
  ssh_user         = "${var.ssh_user}"
  ssh_key_location = "${var.ssh_key_location}"
}
module "server-3" {
  source           = "./server"
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  identity         = "${var.identity}"
  key_name         = "${var.key_name}"
  resource_name    = "k8s-master1"
  ssh_user         = "${var.ssh_user}"
  ssh_key_location = "${var.ssh_key_location}"
}
module "server-4" {
  source           = "./server"
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  identity         = "${var.identity}"
  key_name         = "${var.key_name}"
  resource_name    = "k8s-master2"
  ssh_user         = "${var.ssh_user}"
  ssh_key_location = "${var.ssh_key_location}"
}
module "server-5" {
  source           = "./server"
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  identity         = "${var.identity}"
  key_name         = "${var.key_name}"
  resource_name    = "k8s-master3"
  ssh_user         = "${var.ssh_user}"
  ssh_key_location = "${var.ssh_key_location}"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["212.250.145.34/32"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.250.145.34/32"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "k8s-secgroup"
  }
}
resource "aws_default_subnet" "default" {
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Default subnet for eu-west-1"
  }

}
# output "public_ip" {
#   value = "${module.server.public_ip}"
# }

# output "public_dns" {
#   value = "${module.server.public_dns}"
# }
