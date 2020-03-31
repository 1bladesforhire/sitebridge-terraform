# !PROCEED WITH CAUTION!PROCEED WITH CAUTION!PROCEED WITH CAUTION!PROCEED WITH CAUTION!
# This was auto-generated by the Terraform provisioning process for the pipeline.
# Changing the values below could cause the pipeline to quit working.
terraform {
  backend "s3" {
    bucket         = "sitebridge-terraform-deploy-aws-dev-artifacts"
    key            = "state/sitebridge-terraform-deploy-aws-dev.tfstate"
    encrypt        = true
    kms_key_id     = "3925d0ee-f32c-441b-83d5-84e6575a52b3"
    dynamodb_table = "sitebridge-terraform-deploy-aws-dev-state-lock"
    role_arn       = "arn:aws:iam::099350349688:role/sitebridge-terraform/sitebridge-terraform"
    external_id    = "Terraform"
    region         = "us-west-2"
  }
}

provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::099350349688:role/sitebridge-terraform/sitebridge-terraform"
    external_id = "Terraform"
  }

  region = "us-west-2"
}
