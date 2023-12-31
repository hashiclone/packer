packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "autogenerated_1" {
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "ansible-local" {
  }

  post-processor "googlecompute-import" {
  }
}
