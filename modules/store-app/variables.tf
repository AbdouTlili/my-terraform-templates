variable "ami" {
    type = string
    description = "ami for an ubuntu VM 22.04"
}


variable "instance_type" {
    default = "t2.micro"
}


variable "app_region" {
    type = string
}

variable "bucket" {
    default = "store-bucket-25a9-866d"
}