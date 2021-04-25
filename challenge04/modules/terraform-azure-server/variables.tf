variable "servername" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "rgname" {
  type = string
}

variable "location" {
  type = string
}

variable "os" {
  type = object({
      publisher = string
      offer = string
      sku = string
      version = string
  })
}