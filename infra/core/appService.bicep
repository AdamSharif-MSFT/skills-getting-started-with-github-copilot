// Parameters
@description('Name of the App Service Plan')
param appServicePlanName string

@description('Name of the Web App')
param webAppName string

@description('Location for resources')
param location string = resourceGroup().location

@description('Tags for resources')
param tags object = {}

@description('Container Registry login server')
param containerRegistryLoginServer string

@description('Docker image name')
param dockerImageName string = 'zava-storefront:latest'

@description('Application Insights Connection String')
param applicationInsightsConnectionString string = ''

// App Service Plan (Linux)
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true // Required for Linux
  }
}

// Web App with Container
resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  tags: tags
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryLoginServer}/${dockerImageName}'
      alwaysOn: true
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${containerRegistryLoginServer}'
        }
        {
          name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsConnectionString
        }
      ]
      acrUseManagedIdentityCreds: true // Use managed identity for ACR
    }
  }
}

// Outputs
output webAppName string = webApp.name
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output webAppPrincipalId string = webApp.identity.principalId
output appServicePlanId string = appServicePlan.id
