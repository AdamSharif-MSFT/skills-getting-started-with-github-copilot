// Parameters
@description('Name of the AI Hub')
param hubName string

@description('Location for AI resources')
param location string = resourceGroup().location

@description('Tags for AI resources')
param tags object = {}

@description('Log Analytics Workspace ID')
param workspaceId string

@description('Application Insights ID')
param applicationInsightsId string

@description('Storage Account ID')
param storageAccountId string = ''

@description('Key Vault ID')
param keyVaultId string = ''

// Storage Account for AI Hub (if not provided)
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = if (empty(storageAccountId)) {
  name: '${replace(hubName, '-', '')}st'
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

// Key Vault for AI Hub (if not provided)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = if (empty(keyVaultId)) {
  name: '${hubName}-kv'
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

// AI Hub (formerly AI Foundry)
resource aiHub 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: hubName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: hubName
    storageAccount: empty(storageAccountId) ? storageAccount.id : storageAccountId
    keyVault: empty(keyVaultId) ? keyVault.id : keyVaultId
    applicationInsights: applicationInsightsId
    publicNetworkAccess: 'Enabled'
  }
}

// AI Services Account for GPT-4 and Phi models
resource aiServices 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: '${hubName}-aiservices'
  location: location
  tags: tags
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: '${hubName}-aiservices'
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

// Outputs
output aiHubId string = aiHub.id
output aiHubName string = aiHub.name
output aiServicesId string = aiServices.id
output aiServicesName string = aiServices.name
output aiServicesEndpoint string = aiServices.properties.endpoint
output storageAccountId string = empty(storageAccountId) ? storageAccount.id : storageAccountId
output keyVaultId string = empty(keyVaultId) ? keyVault.id : keyVaultId
