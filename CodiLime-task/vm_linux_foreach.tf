########################################################################################################################

resource "azurerm_virtual_network" "infra" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  address_space       = ["10.0.0.0/16"]
}
########################################################################################################################

resource "azurerm_subnet" "infra" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = ["10.0.1.0/24"]
}
########################################################################################################################

resource "azurerm_public_ip" "linux" {
  name                = "linux-publicip"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  allocation_method   = "Static"
}
########################################################################################################################

resource "azurerm_network_interface" "linux" {
  for_each             = var.instances
  name                = "${each.key}-nic"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  ip_configuration {
    name                          = var.linux_ip_configuration_name
    subnet_id                     = azurerm_subnet.infra.id
    private_ip_address_allocation = "Dynamic"
    #sku                 = "Standard"
    #zones               = ["1", "2", "3"]
    # public_ip_address_id          = azurerm_public_ip.linux.id
    #load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.pool.id]
  }
}

########################################################################################################################

resource "azurerm_linux_virtual_machine" "linux" {
  for_each             = var.instances
  name                = "${each.key}-vm"
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  size                = var.linux_vm_size
  
  #delete_os_disk_on_termination    = true
  #delete_data_disks_on_termination = true

  network_interface_ids = [azurerm_network_interface.linux[each.key].id]
  #load_balancer_inbound_nat_rules_ids     = [azurerm_lb_nat_rule.natrule.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.linux_image_publisher
    offer     = var.linux_image_offer
    sku       = var.linux_image_sku
    version   = var.linux_image_version
  }  
  
  admin_ssh_key {
    username   = var.linux_admin_username
    public_key = file(var.public_key_file)
  }
  
  availability_set_id = azurerm_availability_set.avset.id  
  disable_password_authentication = true
  computer_name   = var.linux_vm_name
  admin_username   = var.linux_admin_username
  #admin_password   = var.linux_admin_password

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 80:80 nginxdemos/hello"
    ]

    connection {
      type        = "ssh"
      user        = var.linux_admin_username
      #password    = "P@ssw0rd123!"
      private_key = file(var.private_key_file)
      host         = azurerm_public_ip.linux.ip_address
    }
  }  
}