resource "azurerm_public_ip" "gateway" {
  name                = "${var.name}-zta-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Coder_Provisioned = "true"
  }
}

resource "azurerm_network_interface" "gateway" {
  name                = "${var.name}-zta-gateway-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "${var.name}-zta-gateway"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.gateway.id
  }
}

resource "azurerm_network_interface_security_group_association" "gateway" {
  network_interface_id      = azurerm_network_interface.gateway.id
  network_security_group_id = azurerm_network_security_group.gateway.id
}

resource "azurerm_linux_virtual_machine" "gateway" {
  name                = "${var.name}-zta-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.gateway.id,
  ]

  # This is replaced by the cloud init script and is only here to satisfy the
  # Azure requirement.
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  user_data = base64encode(templatefile("${path.module}/files/cloud-config.yaml", {
    activation_token = var.gateway_token
    public_ip        = azurerm_public_ip.gateway.ip_address
    tags             = jsonencode(["${var.name}"])
  }))
}
