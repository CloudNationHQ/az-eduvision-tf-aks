# This example was copied from: https://learn.microsoft.com/en-us/azure/developer/terraform/deploy-application-gateway-v2



resource "azurerm_user_assigned_identity" "appgateway" {
  name                = module.naming.user_assigned_identity.name_unique
  location            = module.rg.groups.default.location
  resource_group_name = module.rg.groups.default.name
}

# resource "azurerm_role_assignment" "appgateway_tlsinspection_cert_reader" {
#   scope                = var.tlsinspection_cert.resource_versionless_id
#   role_definition_name = "Key Vault Reader"
#   principal_id         = azurerm_user_assigned_identity.appgateway.principal_id
# }


resource "azurerm_public_ip" "pip" {
  name                = module.naming.public_ip.name_unique
  resource_group_name = module.rg.groups.default.name
  location            = module.rg.groups.default.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  http_frontend_port_name        = "HttpsFrontendPort"
  http_listener_name             = "nginx"
  backend_address_pool_name      = "nginx"
  frontend_ip_configuration_name = "nginx"
  backend_http_settings_name     = "nginx"
}

resource "azurerm_application_gateway" "main" {
  name                = module.naming.application_gateway.name_unique
  resource_group_name = module.rg.groups.default.name
  location            = module.rg.groups.default.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  # frontend_port {
  #   name = var.frontend_port_name
  #   port = 80
  # }

  frontend_port {
    name = local.http_frontend_port_name
    port = 80
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.http_frontend_port_name
    protocol                       = "Http"
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    # Instead of ip_addresses you should use fqdns
    #fqdns = ["backend.someprivatednszone"]
    ip_addresses = ["10.0.0.0"]
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool,
    ]
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    #host_name                      = "backend.carlintveld.nl"
    #trusted_root_certificate_names = ["tlsinspection"]
  }

  # request_routing_rule {
  #   name                       = var.request_routing_rule_name
  #   rule_type                  = "Basic"
  #   http_listener_name         = var.listener_name
  #   # backend_address_pool_name  = var.backend_address_pool_name
  #   backend_address_pool_name  = "aciBackend"
  #   backend_http_settings_name = var.http_setting_name
  #   priority                   = 1
  # }

  request_routing_rule {
    name                       = "nginx"
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority                   = 1
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.appgateway.id,
    ]
  }
}
