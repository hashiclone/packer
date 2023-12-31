packer {
  required_version = ">= 1.6.0"
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "aws_access_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "aws_region" {
  type = string
}

variable "aws_secondary_region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

variable "aws_secret_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secret_account" {
  type      = string
  default   = "🤷"
  sensitive = true
}

data "amazon-secretsmanager" "autogenerated_1" {
  name = "sample/app/password"
}

data "amazon-secretsmanager" "autogenerated_2" {
  key  = "api_key"
  name = "sample/app/passwords"
}

data "amazon-secretsmanager" "autogenerated_3" {
  name = "some_secret"
}

data "amazon-secretsmanager" "autogenerated_4" {
  key  = "with_key"
  name = "some_secret"
}

data "amazon-ami" "autogenerated_1" {
  access_key = "${var.aws_access_key}"
  filters = {
    name                = "ubuntu/images/*/ubuntu-xenial-16.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.aws_region}"
  secret_key  = "${var.aws_secret_key}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

local "password" {
  sensitive  = true
  expression = "${data.amazon-secretsmanager.autogenerated_1.value}"
}

locals {
  password_key = "MY_KEY_${data.amazon-secretsmanager.autogenerated_2.value}"
}

source "amazon-ebs" "autogenerated_1" {
  access_key      = "${var.aws_access_key}"
  ami_description = "Ubuntu 16.04 LTS - expand root partition"
  ami_name        = "ubuntu-16-04-test-${local.timestamp}"
  encrypt_boot    = true
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 48
    volume_type           = "gp2"
  }
  region              = "${var.aws_region}"
  secret_key          = "${var.aws_secret_key}"
  source_ami          = "${data.amazon-ami.autogenerated_1.id}"
  spot_instance_types = ["t2.small", "t2.medium", "t2.large"]
  spot_price          = "0.0075"
  ssh_interface       = "session_manager"
  ssh_username        = "ubuntu"
  temporary_iam_instance_profile_policy_document {
    Statement {
      Action   = ["*"]
      Effect   = "Allow"
      Resource = ["*"]
    }
    Version = "2012-10-17"
  }
}

source "amazon-ebs" "named_builder" {
  access_key      = "${var.aws_access_key}"
  ami_description = "Ubuntu 16.04 LTS - expand root partition"
  ami_name        = "ubuntu-16-04-test-${local.timestamp}"
  encrypt_boot    = true
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 48
    volume_type           = "gp2"
  }
  region              = "${var.aws_region}"
  secret_key          = "${var.aws_secret_key}"
  source_ami          = "${data.amazon-ami.autogenerated_1.id}"
  spot_instance_types = ["t2.small", "t2.medium", "t2.large"]
  spot_price          = "0.0075"
  ssh_interface       = "session_manager"
  ssh_username        = "ubuntu"
  temporary_iam_instance_profile_policy_document {
    Statement {
      Action   = ["*"]
      Effect   = "Allow"
      Resource = ["*"]
    }
    Version = "2012-10-17"
  }
}

build {
  sources = ["source.amazon-ebs.autogenerated_1", "source.amazon-ebs.named_builder"]

  provisioner "shell" {
    except      = ["amazon-ebs"]
    inline      = ["echo ${var.secret_account}", "echo ${build.ID}", "echo ${build.SSHPublicKey} | head -c 14", "echo ${path.root} is not ${path.cwd}", "echo ${packer.version}", "echo ${uuidv4()}"]
    max_retries = "5"
  }

  provisioner "shell" {
    inline = ["echo ${local.password}", "echo ${data.amazon-secretsmanager.autogenerated_1.value}", "echo ${local.password_key}", "echo ${data.amazon-secretsmanager.autogenerated_2.value}"]
  }

  provisioner "shell" {
    inline = ["echo ${data.amazon-secretsmanager.autogenerated_3.value}", "echo ${data.amazon-secretsmanager.autogenerated_4.value}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "clean_resource_name" call:
  # there is no way to automatically upgrade the "clean_resource_name" call.
  # Please manually upgrade to use custom validation rules, `replace(string, substring, replacement)` or `regex_replace(string, substring, replacement)`
  # Visit https://packer.io/docs/templates/hcl_templates/variables#custom-validation-rules , https://www.packer.io/docs/templates/hcl_templates/functions/string/replace or https://www.packer.io/docs/templates/hcl_templates/functions/string/regex_replace for more infos.
  provisioner "shell" {
    inline = ["echo mybuild-{{ clean_resource_name `${timestamp()}` }}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "lower" call:
  # there is no way to automatically upgrade the "lower" call.
  # Please manually upgrade to `lower(var.example)`
  # Visit https://www.packer.io/docs/templates/hcl_templates/functions/string/lower for more infos.
  provisioner "shell" {
    inline = ["echo {{ lower `SOMETHING` }}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "upper" call:
  # there is no way to automatically upgrade the "upper" call.
  # Please manually upgrade to `upper(var.example)`
  # Visit https://www.packer.io/docs/templates/hcl_templates/functions/string/upper for more infos.
  provisioner "shell" {
    inline = ["echo {{ upper `something` }}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "split" call:
  # there is no way to automatically upgrade the "split" call.
  # Please manually upgrade to `split(separator, string)`
  # Visit https://www.packer.io/docs/templates/hcl_templates/functions/string/split for more infos.
  provisioner "shell" {
    inline = ["echo {{ split `some-string` `-` 0 }}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "replace_all" call:
  # there is no way to automatically upgrade the "replace_all" call.
  # Please manually upgrade to `replace(string, substring, replacement)` or `regex_replace(string, substring, replacement)`
  # Visit https://www.packer.io/docs/templates/hcl_templates/functions/string/replace or https://www.packer.io/docs/templates/hcl_templates/functions/string/regex_replace for more infos.
  provisioner "shell" {
    inline = ["echo {{ replace_all `-` `/` `${build.name}` }}"]
  }


  # 1 error occurred upgrading the following block:
  # unhandled "replace" call:
  # there is no way to automatically upgrade the "replace" call.
  # Please manually upgrade to `replace(string, substring, replacement)` or `regex_replace(string, substring, replacement)`
  # Visit https://www.packer.io/docs/templates/hcl_templates/functions/string/replace or https://www.packer.io/docs/templates/hcl_templates/functions/string/regex_replace for more infos.
  provisioner "shell" {
    inline = ["echo {{ replace `some-string` `-` `/` 1 }}"]
  }

  provisioner "shell-local" {
    inline  = ["sleep 100000"]
    only    = ["amazon-ebs"]
    timeout = "5s"
  }

  post-processor "amazon-import" {
    format         = "vmdk"
    license_type   = "BYOL"
    region         = "eu-west-3"
    s3_bucket_name = "hashicorp.adrien"
    tags = {
      Description = "packer amazon-import ${local.timestamp}"
    }
  }
  post-processors {
    post-processor "artifice" {
      keep_input_artifact = true
      files               = ["path/something.ova"]
      name                = "very_special_artifice_post-processor"
      only                = ["amazon-ebs"]
    }
    post-processor "amazon-import" {
      except         = ["amazon-ebs"]
      license_type   = "BYOL"
      s3_bucket_name = "hashicorp.adrien"
      tags = {
        Description = "packer amazon-import ${local.timestamp}"
      }
    }
  }
}
