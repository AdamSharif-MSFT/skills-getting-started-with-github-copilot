// Parameters
@description('Principal ID of the managed identity')
param principalId string

@description('Container Registry ID')
param containerRegistryId string

// Role Definition ID for AcrPull
var acrPullRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

// Role Assignment
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistryId, principalId, acrPullRoleDefinitionId)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: acrPullRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

// Outputs
output roleAssignmentId string = acrPullRoleAssignment.id
