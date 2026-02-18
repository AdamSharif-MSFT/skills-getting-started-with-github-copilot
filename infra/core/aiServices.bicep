@description('Name of the Azure AI Services account')
param name string

@description('Location for the Azure AI Services account')
param location string = resourceGroup().location

@description('Tags to apply to the Azure AI Services account')
param tags object = {}

@description('SKU of the Azure AI Services account')
param sku string = 'S0'

@description('Custom subdomain name')
param customSubDomainName string = name

resource aiServices 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  kind: 'CognitiveServices'
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: customSubDomainName
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

output id string = aiServices.id
output name string = aiServices.name
output endpoint string = aiServices.properties.endpoint
