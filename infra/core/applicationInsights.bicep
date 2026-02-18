// Parameters
@description('Name of the Application Insights instance')
param name string

@description('Location for Application Insights')
param location string = resourceGroup().location

@description('Tags for Application Insights')
param tags object = {}

@description('Log Analytics Workspace ID')
param workspaceId string

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Outputs
output id string = applicationInsights.id
output name string = applicationInsights.name
output instrumentationKey string = applicationInsights.properties.InstrumentationKey
output connectionString string = applicationInsights.properties.ConnectionString
