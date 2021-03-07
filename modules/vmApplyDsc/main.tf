resource "azurerm_resource_group" "vmtest" {
  name     = var.vm_resource_group
  location = var.location
}

resource "azurerm_virtual_network" "vmtest" {
  name                = var.vm_vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vmtest.location
  resource_group_name = azurerm_resource_group.vmtest.name
}

resource "azurerm_subnet" "vmtest" {
  name                 = "acctsubrac"
  resource_group_name  = azurerm_resource_group.vmtest.name
  virtual_network_name = azurerm_virtual_network.vmtest.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vmtest" {
  name                = var.vm_subnet_name
  location            = azurerm_resource_group.vmtest.location
  resource_group_name = azurerm_resource_group.vmtest.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.vmtest.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vmtest" {
  name                  = var.vm_name
  location              = azurerm_resource_group.vmtest.location
  resource_group_name   = azurerm_resource_group.vmtest.name
  network_interface_ids = [azurerm_network_interface.vmtest.id]
  vm_size               = "Standard_F2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "acctracvm"
    admin_username = "testadmin"
    admin_password = var.vm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "vmtest" {
  name                 = var.vm_extension_name
  virtual_machine_id   = azurerm_virtual_machine.vmtest.id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"
  depends_on           = [azurerm_virtual_machine.vmtest]

  settings = <<SETTINGS
    {
      "configurationArguments": {
          "RegistrationUrl": "${var.automation_account_dsc_server_endpoint}",
          "NodeConfigurationName": "${var.dsc_config_name}"
      }
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "configurationArguments": {
        "registrationKey": {
          "userName": "NOT_USED",
          "Password": "${var.automation_account_access_key}"
        }
      }
    }
  PROTECTED_SETTINGS
}