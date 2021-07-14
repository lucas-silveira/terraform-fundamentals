variable "key_name" {
  type = string
  default = "terraform-aws"
}

variable "amis" {
  type = map
  default = {
    "us_east_1" = "ami-0dc2d3e4c0f9ebd18"
    "us_east_2" = "ami-0233c2d874b811deb"
  }
}

variable "cidr_remote_access" {
  type = list
  default = ["45.163.87.89/32"]
}