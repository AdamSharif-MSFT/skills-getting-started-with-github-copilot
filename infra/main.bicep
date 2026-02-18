targetScope = 'subscription'

// Parameters
@description('Name of the environment (e.g., dev, test, prod)')
@minLength(1)
@maxLength(10)
param environmentName string

@description('Primary location for all resources')
param location string = 'westus3'

@description('Unique suffix for resource names')
param resourceToken string = uniqueString(subscription().id, environmentName, location)

@description('Tags for all resources')
param tags object = {
  'azd-env-name': environmentName
  environment: 'dev'
  project: 'zava-storefront'
}

// Variables
var resourceGroupName = 'rg-${environmentName}-${resourceToken}'
var containerRegistryName = 'cr${replace(environmentName, '-', '')}${resourceToken}'
var appServicePlanName = 'asp-${environmentName}-${resourceToken}'
var webAppName = 'app-${environmentName}-${resourceToken}'
var logAnalyticsName = 'log-${environmentName}-${resourceToken}'
var appInsightsName = 'appi-${environmentName}-${resourceToken}'
var aiHubName = 'aihub-${environmentName}-${resourceToken}'

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Log Analytics Workspace
module logAnalytics './core/logAnalytics.bicep' = {
  name: 'logAnalytics'
  scope: resourceGroup
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
    sku: 'PerGB2018'
    retentionInDays: 30
  }
}

// Application Insights
module applicationInsights './core/applicationInsights.bicep' = {
  name: 'applicationInsights'
  scope: resourceGroup
  params: {
    name: appInsightsName
    location: location
    tags: tags
    workspaceId: logAnalytics.outputs.id
  }
}

// Container Registry
module containerRegistry './core/containerRegistry.bicep' = {
  name: 'containerRegistry'
  scope: resourceGroup
  params: {
    name: containerRegistryName
    location: location
    tags: tags
    sku: 'Basic'
  }
}

// App Service (Web App with Container)
module appService './core/appService.bicep' = {
  name: 'appService'
  scope: resourceGroup
  params: {
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    location: location
    tags: tags
    containerRegistryLoginServer: containerRegistry.outputs.loginServer
    dockerImageName: 'zava-storefront:latest'
    applicationInsightsConnectionString: applicationInsights.outputs.connectionString
  }
}

// ACR Role Assignment (AcrPull for App Service)
module acrRoleAssignment './core/acrRoleAssignment.bicep' = {
  name: 'acrRoleAssignment'
  scope: resourceGroup
  params: {
    principalId: appService.outputs.webAppPrincipalId
    containerRegistryId: containerRegistry.outputs.id
  }
}

// AI Foundry (Azure AI Hub for GPT-4 and Phi)
module aiFoundry './core/aiFoundry.bicep' = {
  name: 'aiFoundry'
  scope: resourceGroup
  params: {
    hubName: aiHubName
    location: location
    tags: tags
    workspaceId: logAnalytics.outputs.id
    applicationInsightsId: applicationInsights.outputs.id
  }
}

// Outputs
output AZURE_LOCATION string = location
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.name
output SERVICE_WEB_NAME string = appService.outputs.webAppName
output SERVICE_WEB_URL string = appService.outputs.webAppUrl
output APPLICATIONINSIGHTS_CONNECTION_STRING string = applicationInsights.outputs.connectionString
output AZURE_AI_HUB_NAME string = aiFoundry.outputs.aiHubName
output AZURE_AI_SERVICES_ENDPOINT string = aiFoundry.outputs.aiServicesEndpoint
