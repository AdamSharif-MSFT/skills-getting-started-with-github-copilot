targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment used to generate unique resource names')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string = 'westus3'

@description('Name of the resource group')
param resourceGroupName string = ''

@description('Name of the container registry')
param containerRegistryName string = ''

@description('Name of the App Service Plan')
param appServicePlanName string = ''

@description('Name of the App Service')
param appServiceName string = ''

@description('Name of the Application Insights instance')
param applicationInsightsName string = ''

@description('Name of the Log Analytics workspace')
param logAnalyticsName string = ''

@description('Name of the Azure AI Services account')
param aiServicesName string = ''

@description('Docker image name and tag')
param imageName string = 'zavastorefrontapp:latest'

// Generate unique names using environment name
var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  azdEnvName: environmentName
  environment: 'dev'
  application: 'ZavaStorefront'
}

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// Log Analytics Workspace for Application Insights
module logAnalytics './core/logAnalytics.bicep' = {
  name: 'logAnalytics'
  scope: rg
  params: {
    name: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    location: location
    tags: tags
  }
}

// Application Insights
module applicationInsights './core/applicationInsights.bicep' = {
  name: 'applicationInsights'
  scope: rg
  params: {
    name: !empty(applicationInsightsName) ? applicationInsightsName : '${abbrs.insightsComponents}${resourceToken}'
    location: location
    tags: tags
    workspaceId: logAnalytics.outputs.id
  }
}

// Container Registry
module containerRegistry './core/containerRegistry.bicep' = {
  name: 'containerRegistry'
  scope: rg
  params: {
    name: !empty(containerRegistryName) ? containerRegistryName : '${abbrs.containerRegistryRegistries}${resourceToken}'
    location: location
    tags: tags
  }
}

// App Service Plan (Linux)
module appServicePlan './core/appServicePlan.bicep' = {
  name: 'appServicePlan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'B1'
      tier: 'Basic'
      capacity: 1
    }
    kind: 'linux'
    reserved: true
  }
}

// App Service with Docker and RBAC to Container Registry
module appService './core/appService.bicep' = {
  name: 'appService'
  scope: rg
  params: {
    name: !empty(appServiceName) ? appServiceName : '${abbrs.webSitesAppService}${resourceToken}'
    location: location
    tags: tags
    appServicePlanId: appServicePlan.outputs.id
    containerRegistryName: containerRegistry.outputs.name
    imageName: imageName
    applicationInsightsConnectionString: applicationInsights.outputs.connectionString
    applicationInsightsInstrumentationKey: applicationInsights.outputs.instrumentationKey
  }
}

// Assign AcrPull role to App Service's managed identity
module acrPullRoleAssignment './core/acrRoleAssignment.bicep' = {
  name: 'acrPullRoleAssignment'
  scope: rg
  params: {
    containerRegistryName: containerRegistry.outputs.name
    principalId: appService.outputs.identityPrincipalId
    roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull role
  }
}

// Azure AI Services (for GPT-4 and Phi models)
module aiServices './core/aiServices.bicep' = {
  name: 'aiServices'
  scope: rg
  params: {
    name: !empty(aiServicesName) ? aiServicesName : '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    location: location
    tags: tags
    sku: 'S0'
  }
}

// Outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.name

output AZURE_APP_SERVICE_NAME string = appService.outputs.name
output AZURE_APP_SERVICE_URL string = appService.outputs.uri

output APPLICATIONINSIGHTS_CONNECTION_STRING string = applicationInsights.outputs.connectionString
output APPLICATIONINSIGHTS_INSTRUMENTATION_KEY string = applicationInsights.outputs.instrumentationKey

output AZURE_AI_SERVICES_ENDPOINT string = aiServices.outputs.endpoint
output AZURE_AI_SERVICES_NAME string = aiServices.outputs.name
