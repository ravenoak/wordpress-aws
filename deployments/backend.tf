terraform {
  backend "s3" {
    bucket         = "terraform-state-816069151329"
    key            = "wordpress.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    assume_role {
      role_arn = "arn:aws:iam::816069151329:role/wordpress-terraform-state"
    }
  }
}
