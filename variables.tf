variable "name" {
  default = "test-http-app"
}

variable "region" {
  default = "eu-north-1"
  description = "Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-north-1a", "eu-north-1b"]
}


variable "cidr_vpc" {
  type        = string
  description = "VPC CIRD value"
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnets" {
  type        = list(string)
  description = "Pyblic Subnet CIRD values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_private_subnets" {
  type        = list(string)
  description = "Private Subnet CIRD values"
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "test-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.32"
}