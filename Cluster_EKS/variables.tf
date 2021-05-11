#
# Variables Configuration
#

variable "cluster-name" {
  type = string
}

variable "aws_region" {
  default     = "us-west-2"
  type        = string
  description = "aws region"
}
