@description('Name of the Application Insights instance')
param name string

@description('Location for Application Insights')
param location string = resourceGroup().location

@description('Tags to apply to Application Insights')
param tags object = {}

@description('Log Analytics workspace ID')
param workspaceId string

@description('Application type')
param kind string = 'web'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: kind
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    WorkspaceResourceId: workspaceId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output id string = applicationInsights.id
output name string = applicationInsights.name
output connectionString string = applicationInsights.properties.ConnectionString
output instrumentationKey string = applicationInsights.properties.InstrumentationKey
