// Parameters
@description('Name of the Log Analytics Workspace')
param name string

@description('Location for the Log Analytics Workspace')
param location string = resourceGroup().location

@description('Tags for the Log Analytics Workspace')
param tags object = {}

@description('SKU for the Log Analytics Workspace')
@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
param sku string = 'PerGB2018'

@description('Retention period in days')
param retentionInDays int = 30

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
  }
}

// Outputs
output id string = logAnalyticsWorkspace.id
output name string = logAnalyticsWorkspace.name
output customerId string = logAnalyticsWorkspace.properties.customerId
