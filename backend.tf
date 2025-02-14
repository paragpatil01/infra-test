terraform {
  backend "s3" {
    bucket        = "infrabucket25"  # Replace with your bucket name
    key           = "infra-test/terraform.tfstate"           # Path in S3
    region        = "us-east-1"                   # Change to your AWS region
    encrypt       = true
    dynamodb_table = "LockFiles"             # Table for state locking
  }
}



/*-----------------------------------------*/

