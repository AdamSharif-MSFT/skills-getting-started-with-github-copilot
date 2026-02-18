// Parameters
@description('Name of the Container Registry')
param name string

@description('Location for the Container Registry')
param location string = resourceGroup().location

@description('Tags for the Container Registry')
param tags object = {}

@description('SKU for the Container Registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: false // Use managed identity instead of admin credentials
    publicNetworkAccess: 'Enabled'
  }
}

// Outputs
output loginServer string = containerRegistry.properties.loginServer
output name string = containerRegistry.name
output id string = containerRegistry.id
