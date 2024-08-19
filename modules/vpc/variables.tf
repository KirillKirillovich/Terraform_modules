variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "tags" {
  default = {
    Name = "custom vpc"
    Additional = "Some additional tag"
  }
}

variable "public_ip_launch" {
  type = bool
  default = true
}

variable "public_subnet_cidr" {
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_cidr" {
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "available_zones" {
 default     = ["eu-central-1a", "eu-central-1b"]
}

variable "sg_allowed_ports" {
  default = ["80", "22"]
}