terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "eu-central-1"
  profile = "techstarter"

  #   access_key = "my-access-key"
  #   secret_key = "my-secret-key"
  #   token = "my-token"

}






