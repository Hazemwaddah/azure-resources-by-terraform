variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resources"
  type        = string
}

variable "availability_set_id" {
  type = string
  default = "/subscriptions/2082bb2a-22e8-46c6-a2c7-63d706da03a0/resourceGroups/azure_testing_environment/providers/Microsoft.Compute/availabilitySets/avset"
}

variable "instances" {
  description = "The map of instances to create"
  default = {
    instance1 = "adminuser1"
    instance2 = "adminuser2"
  }
}

########################################################################################################################

# linux-server 

variable "linux_network_interface_name" {}
variable "linux_ip_configuration_name" {}
variable "linux_vm_name" {}
variable "linux_vm_size" {}
variable "linux_image_publisher" {}
variable "linux_image_sku" {}
variable "linux_image_version" {}
variable "linux_image_offer" {}
variable "linux_admin_username" {}

variable "virtual_network_name" {}
variable "subnet_name" {}
variable "load_balancer" {}
variable "control_vm_ip" {}
variable "private_key_file" {}
variable "public_key_file" {}

#variable "public_ip" {}
#variable "availability_set_id" {}