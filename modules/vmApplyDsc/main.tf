resource "azurerm_resource_group" "vmtest" {
  name     = "vm-resources"
  location = var.LOCATION
}

resource "azurerm_virtual_network" "vmtest" {
  name                = "acctvnrac"
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
  name                = "acctnirac"
  location            = azurerm_resource_group.vmtest.location
  resource_group_name = azurerm_resource_group.vmtest.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.vmtest.id
    private_ip_address_allocation = "Dynamic"
  }
}

# resource "azurerm_storage_account" "vmtest" {
#   name                     = "accsatestrac"
#   location            = azurerm_resource_group.vmtest.location
#   resource_group_name = azurerm_resource_group.vmtest.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = "staging"
#   }
# }

# resource "azurerm_storage_container" "vmtest" {
#   name                  = "vhds"
#   storage_account_name  = azurerm_storage_account.vmtest.name
#   container_access_type = "blob"
# }

resource "azurerm_virtual_machine" "vmtest" {
  name                  = "acctracvm"
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
    admin_password = "Password1234!"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "vmtest" {
  name                 = "dscConf1"
  virtual_machine_id   = azurerm_virtual_machine.vmtest.id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"
  depends_on           = [azurerm_virtual_machine.vmtest]

  settings = <<SETTINGS
    {
      "configurationArguments": {
          "RegistrationUrl": "${azurerm_automation_account.automation_account.dsc_server_endpoint}",
          "NodeConfigurationName": "${var.DSCCONF1_CONFIG_NAME}"
      }
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "configurationArguments": {
        "registrationKey": {
          "userName": "NOT_USED",
          "Password": "${azurerm_automation_account.automation_account.dsc_primary_access_key}"
        }
      }
    }
  PROTECTED_SETTINGS
}