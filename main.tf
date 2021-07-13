terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

resource "aws_instance" "dev" {
  count                  = 1
  ami                    = "ami-0dc2d3e4c0f9ebd18"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] // reference
  tags = {
    Name = "Instance ${count.index}" // e.g: Instance 1
  }
}

resource "aws_instance" "dev2" {
  ami                    = "ami-0dc2d3e4c0f9ebd18"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  depends_on             = [aws_s3_bucket.dev2]
  tags = {
    Name = "Instance 2"
  }
}

resource "aws_instance" "dev3" {
  provider               = aws.us_east_2
  ami                    = "ami-0233c2d874b811deb"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = [aws_security_group.allow_ssh_us_east_2.id]
  depends_on             = [aws_dynamodb_table.basic_table]
  tags = {
    Name = "Instance 3"
  }
}

resource "aws_s3_bucket" "dev2" {
  bucket = "bucket-dev2"
  acl    = "private"

  tags = {
    Name = "bucket-dev2"
  }
}

resource "aws_dynamodb_table" "basic_table" {
  provider = aws.us_east_2
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  tags = {
    Name = "basic-dynamodb-table"
  }
}
