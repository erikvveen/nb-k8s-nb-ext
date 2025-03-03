variable "region" {
  description = "The region where the Linode NodeBalancer will be created"
  default     = "nl-ams"
}

variable "instances_ip" {
  type = list(string)
}

variable "name" {
  description = "The name of the Linode NodeBalancer"
  default     = "talos"
}