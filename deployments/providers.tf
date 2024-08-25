provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::816069151329:role/wordpress-terraform-actor"
  }
}
