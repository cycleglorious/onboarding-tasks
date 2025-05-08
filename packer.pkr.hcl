packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }

  }
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "source_ami" {
  type    = string
  default = "ami-03250b0e01c28d196"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
  ami_name      = "os-hardening-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"
}

build {
  name    = "os-hardening"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}
