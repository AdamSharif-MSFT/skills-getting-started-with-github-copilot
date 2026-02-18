# Azure Infrastructure for ZavaStorefront

This directory contains the Azure infrastructure as code (IaC) using Bicep templates and Azure Developer CLI (azd) configuration.

## Architecture

The infrastructure provisions the following Azure resources in the **westus3** region:

- **Resource Group**: Single resource group containing all resources
- **Container Registry**: Azure Container Registry for Docker images (with RBAC authentication)
- **App Service Plan**: Linux-based Basic B1 tier
- **App Service**: Linux container-based web app with managed identity
- **Application Insights**: Application monitoring and telemetry
- **Log Analytics Workspace**: Centralized logging
- **Azure AI Services**: Cognitive Services for GPT-4 and Phi models

## Prerequisites

- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- Azure subscription

## Deployment

### Using Azure Developer CLI (azd)

1. **Initialize the environment** (first time only):
   ```bash
   azd init
   ```

2. **Login to Azure**:
   ```bash
   azd auth login
   ```

3. **Provision and deploy**:
   ```bash
   azd up
   ```

   This single command will:
   - Provision all Azure resources
   - Build the Docker container
   - Push the container to Azure Container Registry
   - Deploy the container to App Service

### Manual Deployment Steps

If you prefer to deploy step-by-step:

1. **Provision infrastructure only**:
   ```bash
   azd provision
   ```

2. **Deploy application only** (after provisioning):
   ```bash
   azd deploy
   ```

## Configuration

### Environment Variables

The deployment uses the following environment variables (set via `azd env set`):

- `AZURE_ENV_NAME`: Name of the environment (used for resource naming)
- `AZURE_LOCATION`: Azure region (defaults to westus3)

### Resource Naming

Resources are named using the following convention:
- Resource Group: `rg-{environmentName}`
- Container Registry: `cr{uniqueString}`
- App Service Plan: `plan-{uniqueString}`
- App Service: `app-{uniqueString}`
- Application Insights: `appi-{uniqueString}`
- Log Analytics: `log-{uniqueString}`
- AI Services: `cog-{uniqueString}`

The `{uniqueString}` is generated from the subscription ID, environment name, and location to ensure global uniqueness.

## Security Features

- **Managed Identity**: App Service uses system-assigned managed identity
- **RBAC Authentication**: App Service uses Azure RBAC (AcrPull role) to access Container Registry
- **No Passwords**: Container Registry admin user is disabled
- **HTTPS Only**: App Service enforces HTTPS
- **TLS 1.2+**: Minimum TLS version is 1.2

## Monitoring

- **Application Insights**: Automatically configured for the App Service
- **Log Analytics**: Centralized logging for all resources
- Connection strings and instrumentation keys are automatically configured

## Outputs

After deployment, the following information is available via `azd env get-values`:

- `AZURE_CONTAINER_REGISTRY_NAME`: Container registry name
- `AZURE_CONTAINER_REGISTRY_ENDPOINT`: Container registry login server
- `AZURE_APP_SERVICE_NAME`: App Service name
- `AZURE_APP_SERVICE_URL`: App Service URL
- `APPLICATIONINSIGHTS_CONNECTION_STRING`: Application Insights connection string
- `AZURE_AI_SERVICES_ENDPOINT`: Azure AI Services endpoint
- `AZURE_AI_SERVICES_NAME`: Azure AI Services account name

## Clean Up

To delete all provisioned resources:

```bash
azd down
```

This will delete the entire resource group and all contained resources.

## File Structure

```
infra/
├── main.bicep                      # Main infrastructure template
├── main.parameters.json            # Parameters file
├── abbreviations.json              # Resource naming abbreviations
└── core/                           # Reusable Bicep modules
    ├── logAnalytics.bicep          # Log Analytics workspace
    ├── applicationInsights.bicep   # Application Insights
    ├── containerRegistry.bicep     # Container Registry
    ├── appServicePlan.bicep        # App Service Plan
    ├── appService.bicep            # App Service with container support
    ├── acrRoleAssignment.bicep     # RBAC role assignment for ACR
    └── aiServices.bicep            # Azure AI Services
```

## Additional Resources

- [Azure Developer CLI Documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure App Service on Linux](https://learn.microsoft.com/azure/app-service/overview)
- [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/)
- [Azure AI Services](https://learn.microsoft.com/azure/ai-services/)
