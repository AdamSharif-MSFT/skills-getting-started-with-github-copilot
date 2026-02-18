# Azure Infrastructure for ZavaStorefront

This directory contains the Azure infrastructure as code (IaC) using Bicep templates for deploying the ZavaStorefront web application.

## Architecture

The infrastructure includes:

- **Resource Group**: Single resource group containing all resources in westus3 region
- **Container Registry**: Azure Container Registry for storing Docker images (no admin password, uses RBAC)
- **App Service**: Linux App Service with Docker container support
- **Application Insights**: Monitoring and telemetry
- **Log Analytics**: Centralized logging
- **AI Foundry**: Azure AI Hub with AI Services for GPT-4 and Phi models

## Prerequisites

- Azure subscription
- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) installed
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed

## Deployment

### Using Azure Developer CLI (azd)

1. **Initialize the environment:**
   ```bash
   azd init
   ```

2. **Provision the infrastructure:**
   ```bash
   azd provision
   ```

3. **Deploy the application:**
   ```bash
   azd deploy
   ```

4. **Provision and deploy in one command:**
   ```bash
   azd up
   ```

### Using Azure CLI

1. **Login to Azure:**
   ```bash
   az login
   ```

2. **Set the subscription:**
   ```bash
   az account set --subscription <subscription-id>
   ```

3. **Deploy the infrastructure:**
   ```bash
   az deployment sub create \
     --location westus3 \
     --template-file infra/main.bicep \
     --parameters environmentName=dev location=westus3
   ```

## Configuration

The infrastructure is configured for a dev environment with the following settings:

- **Region**: westus3 (for GPT-4 and Phi model availability)
- **Environment**: dev
- **App Service Plan**: Basic (B1) Linux
- **Container Registry**: Basic SKU
- **RBAC**: App Service uses managed identity with AcrPull role to pull images

## Security

- Container Registry has admin user disabled
- App Service uses managed identity for authentication
- All resources use HTTPS only
- RBAC-based access control for Container Registry

## Monitoring

Application Insights is configured to monitor:
- Application performance
- Dependencies
- Exceptions
- Custom metrics

## AI Services

The Azure AI Hub provides access to:
- GPT-4 models
- Phi models
- Other Azure AI services

## Outputs

After deployment, the following outputs are available:

- `AZURE_CONTAINER_REGISTRY_ENDPOINT`: Container Registry login server
- `SERVICE_WEB_URL`: Web application URL
- `APPLICATIONINSIGHTS_CONNECTION_STRING`: Application Insights connection string
- `AZURE_AI_SERVICES_ENDPOINT`: AI Services endpoint

## Resources

For more information, see:
- [Azure Developer CLI documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [Azure Bicep documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure App Service documentation](https://learn.microsoft.com/azure/app-service/)
