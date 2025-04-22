provider "aws" {
  region = var.region
}

provider "hcp" {}

data "hcp_packer_version" "ubuntu" {
  bucket_name  = "ubuntu-image"
  channel_name = "production"
}

data "hcp_packer_artifact" "ubuntu_us_east_2" {
  bucket_name         = "ubuntu-image"
  platform            = "aws"
  version_fingerprint = data.hcp_packer_version.ubuntu.fingerprint
  region              = "us-east-2"
}


resource "aws_instance" "app_server" {
  ami           = data.hcp_packer_artifact.ubuntu_us_east_2.external_identifier
  instance_type = var.size
  tags = {
    Name = "ubuntu-packer-instance"
  }
}
