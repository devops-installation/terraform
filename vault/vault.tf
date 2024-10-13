provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

data "vault_aws_access_credentials" "aws_creds" {
  backend = "aws"
  role    = "terraform-role"
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.aws_creds.access_key
  secret_key = data.vault_aws_access_credentials.aws_creds.secret_key
  region     = "us-east-1"
}

resource "aws_instance" "example-vault" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
