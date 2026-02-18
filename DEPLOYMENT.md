# ZavaStorefront - Azure Deployment Guide

This guide provides step-by-step instructions for deploying the ZavaStorefront web application to Azure using Azure Developer CLI (azd).

## Overview

The deployment creates the following Azure resources in the **westus3** region:

- **Resource Group**: Contains all resources for the application
- **Container Registry**: Stores Docker images (RBAC-based, no passwords)
- **Linux App Service**: Hosts the containerized FastAPI application
- **Application Insights**: Monitors application performance and telemetry
- **Log Analytics Workspace**: Centralized logging
- **Azure AI Hub**: Provides access to GPT-4 and Phi models

## Prerequisites

### Required Tools

1. **Azure Developer CLI (azd)**
   - Install: `brew install azd` (macOS) or see [official docs](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
   - Verify: `azd version`

2. **Azure CLI** (optional, for manual deployments)
   - Install: `brew install azure-cli` (macOS) or see [official docs](https://learn.microsoft.com/cli/azure/install-azure-cli)
   - Verify: `az version`

3. **Docker** is NOT required on your local machine - the build happens in Azure

### Azure Subscription

- An active Azure subscription
- Sufficient permissions to create resources

## Quick Start with Azure Developer CLI

### 1. Login to Azure

```bash
azd auth login
```

This will open a browser for authentication.

### 2. Initialize the Environment

```bash
azd init
```

When prompted:
- **Environment name**: Choose a name (e.g., `dev`, `staging`)
- **Location**: Use `westus3` (required for GPT-4 and Phi models)

### 3. Deploy Everything

```bash
azd up
```

This single command will:
- Provision all Azure infrastructure
- Build the Docker image in Azure (no local Docker needed!)
- Push the image to Azure Container Registry
- Deploy the application to App Service

The deployment typically takes 5-10 minutes.

### 4. Access Your Application

After deployment completes, you'll see output like:

```
Deployment completed successfully!

Outputs:
  SERVICE_WEB_URL: https://app-dev-abc123.azurewebsites.net
  AZURE_AI_SERVICES_ENDPOINT: https://aihub-dev-abc123-aiservices.cognitiveservices.azure.com
```

Visit the `SERVICE_WEB_URL` to see your application running!

## Step-by-Step Deployment (Advanced)

If you want more control over the deployment process:

### 1. Provision Infrastructure Only

```bash
azd provision
```

This creates all Azure resources without deploying the application.

### 2. Deploy Application Only

```bash
azd deploy
```

This builds and deploys the application to existing infrastructure.

### 3. View Deployment Details

```bash
azd show
```

Shows the current environment and deployed resources.

## Environment Configuration

The deployment uses environment variables that can be customized:

```bash
# Set environment name (default: dev)
azd env set AZURE_ENV_NAME production

# Set location (default: westus3)
azd env set AZURE_LOCATION westus3

# View all environment variables
azd env get-values
```

## Updating the Application

After making code changes:

```bash
azd deploy
```

This rebuilds and redeploys only the application (infrastructure unchanged).

## Monitoring and Logs

### View Application Logs

```bash
# Using Azure CLI
az webapp log tail --name <app-name> --resource-group <resource-group>

# Or visit the Azure Portal
```

### Application Insights

Access Application Insights in the Azure Portal to view:
- Performance metrics
- Dependency tracking
- Exception tracking
- Custom telemetry

## Resource Naming Convention

Resources are named using the pattern: `<type>-<environment>-<unique-suffix>`

Examples:
- Resource Group: `rg-dev-abc123`
- Container Registry: `crdevabc123`
- App Service: `app-dev-abc123`
- AI Hub: `aihub-dev-abc123`

## Security Features

- **No passwords**: Container Registry uses RBAC instead of admin credentials
- **Managed Identity**: App Service uses system-assigned managed identity
- **HTTPS Only**: All web traffic is encrypted
- **RBAC**: App Service has AcrPull role to pull images from Container Registry

## Troubleshooting

### Deployment Fails

1. Check the deployment logs: `azd show`
2. Verify your Azure subscription has sufficient quota
3. Ensure you're using `westus3` region

### Application Won't Start

1. Check App Service logs in Azure Portal
2. Verify the Docker image built successfully
3. Check Application Insights for errors

### Cannot Access AI Services

1. Verify AI Hub is deployed: Check Azure Portal
2. Ensure you're in `westus3` region
3. Check service quotas for AI models

## Cleanup

To delete all Azure resources:

```bash
azd down
```

⚠️ This will permanently delete all resources and data!

## Cost Estimation

The dev environment uses:
- App Service Plan: Basic B1 (~$13/month)
- Container Registry: Basic (~$5/month)
- Application Insights: Pay-as-you-go (minimal for dev)
- AI Services: Pay-per-use

Estimated monthly cost: ~$20-30 for light development usage

## Additional Resources

- [Azure Developer CLI Documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [Azure App Service Documentation](https://learn.microsoft.com/azure/app-service/)
- [Azure Container Registry Documentation](https://learn.microsoft.com/azure/container-registry/)
- [Azure AI Services Documentation](https://learn.microsoft.com/azure/ai-services/)

## Support

For issues or questions:
1. Check the [infra/README.md](infra/README.md) for infrastructure details
2. Review Azure Portal for resource status
3. Check Application Insights for application errors
