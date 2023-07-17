### AMI FOR ALL INSTANCES 

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu_ami" {
  ami_name          = "Ubuntu22.04-AMI-${local.timestamp}"
  instance_type     = "t3.small"
  region            = "eu-west-1"
  vpc_id            = "vpc-0718590bbfec836c5"
  subnet_id         = "subnet-071459bd0863e9023"
  security_group_id = "sg-066c692694138c39a"


  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name" = "kibana_ami"
  }

}

build {
  name = "Kibana_packer"
  sources = [
    "source.amazon-ebs.ubuntu_ami"
  ]
}





