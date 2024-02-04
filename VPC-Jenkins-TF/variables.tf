#variables.tf
variable "vpc_cidr" {
 type = string
 description = "CIDR block for VPC"
}
variable "environment" {
 type = string
 description = "Dev or Prod"
}
variable "appname" {
 type = string
 description = "name of app"
}
variable "instance_type" {
 type = string
 description = "Instance type for Ec2"
}
variable "private_subnets_cidr_blocks" {
 type = list(string)
}
variable "public_subnets_cidr_blocks" {
 type = list(string)
}
variable "region" {
  description = "AWS Deployment region.."
  default = "us-east-1"
}
variable "availability_zones" {
  description = "AZs"
}