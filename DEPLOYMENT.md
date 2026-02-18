# Deploying ZavaStorefront to Azure

This guide walks you through deploying the ZavaStorefront web application to Azure using the Azure Developer CLI (azd).

## Overview

The deployment provisions a complete Azure infrastructure for the ZavaStorefront web application including:

- **Linux App Service** running the FastAPI application in a Docker container
- **Azure Container Registry** for storing Docker images
- **Application Insights** for monitoring and telemetry
- **Azure AI Services** for GPT-4 and Phi model access
- **Managed Identity & RBAC** for secure, passwordless container access

All resources are deployed in the **westus3** region in a single resource group.

## Prerequisites

Before you begin, ensure you have:

1. **Azure Developer CLI (azd)** installed
   ```bash
   # Windows (PowerShell)
   winget install microsoft.azd
   
   # macOS
   brew tap azure/azd && brew install azd
   
   # Linux
   curl -fsSL https://aka.ms/install-azd.sh | bash
   ```

2. **Azure subscription** with appropriate permissions to create resources

3. **Docker** is NOT required - Azure Container Registry has a built-in build service

## Quick Start

Deploy everything with a single command:

```bash
# 1. Login to Azure
azd auth login

# 2. Initialize, provision, and deploy
azd up
```

The `azd up` command will:
1. Prompt you for an environment name (e.g., "dev", "staging", "prod")
2. Prompt you to select your Azure subscription
3. Confirm the location (westus3)
4. Provision all Azure resources (5-10 minutes)
5. Build the Docker container in the cloud
6. Deploy the container to App Service

## Step-by-Step Deployment

If you prefer more control, you can run the steps individually:

### 1. Login to Azure

```bash
azd auth login
```

This will open a browser window for you to authenticate with Azure.

### 2. Initialize the Environment

```bash
azd init
```

You'll be prompted to:
- Enter an environment name (e.g., "dev", "myenv")
- Select your Azure subscription
- Confirm or change the location (default: westus3)

### 3. Provision Infrastructure

```bash
azd provision
```

This creates all Azure resources defined in the Bicep templates. It takes approximately 5-10 minutes.

### 4. Deploy Application

```bash
azd deploy
```

This builds the Docker container using Azure Container Registry's build service (no local Docker needed) and deploys it to App Service.

## After Deployment

### Access Your Application

After successful deployment, azd will display the application URL:

```
Application URL: https://app-xyz123.azurewebsites.net
```

You can also retrieve it anytime with:

```bash
azd env get-values | grep AZURE_APP_SERVICE_URL
```

### View Application Logs

Monitor your application in real-time:

```bash
az webapp log tail --name <app-service-name> --resource-group <resource-group-name>
```

Or view logs in the Azure Portal:
1. Navigate to your App Service
2. Go to **Monitoring** > **Log stream**

### Access Application Insights

View telemetry and performance metrics:
1. Navigate to the Azure Portal
2. Find your Application Insights resource
3. Explore metrics, logs, and application map

## Environment Variables

The following environment variables are automatically set in your environment:

```bash
azd env get-values
```

Key variables include:
- `AZURE_APP_SERVICE_URL`: Your application's public URL
- `AZURE_CONTAINER_REGISTRY_NAME`: Container registry name
- `APPLICATIONINSIGHTS_CONNECTION_STRING`: Application Insights connection
- `AZURE_AI_SERVICES_ENDPOINT`: AI Services endpoint

## Updating the Application

To deploy changes to your application:

```bash
# Make your code changes, then:
azd deploy
```

This rebuilds the container and redeploys to App Service.

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
azd show
```

### View Resource Details

```bash
# List all resources in the environment
az resource list --resource-group <resource-group-name> --output table
```

### Container Issues

If the container fails to start:

1. Check App Service logs:
   ```bash
   az webapp log tail --name <app-service-name> --resource-group <resource-group-name>
   ```

2. Verify the container image:
   ```bash
   az acr repository list --name <registry-name>
   az acr repository show-tags --name <registry-name> --repository zavastorefrontapp
   ```

3. Check managed identity permissions:
   ```bash
   az role assignment list --assignee <app-service-identity-id>
   ```

## Clean Up

To delete all resources and avoid ongoing charges:

```bash
azd down
```

This will:
1. Delete the resource group and all contained resources
2. Remove the environment configuration

## Cost Optimization

The deployment uses cost-effective tiers suitable for development:

- **App Service Plan**: Basic B1 (~$13/month)
- **Container Registry**: Basic tier (~$5/month)
- **Application Insights**: Pay-as-you-go (minimal for dev/test)
- **Azure AI Services**: Pay-as-you-go (charged per API call)

For production, consider:
- Scaling App Service Plan to Standard or Premium
- Upgrading Container Registry to Standard for geo-replication
- Configuring auto-scaling and availability zones

## Advanced Scenarios

### Custom Environment Variables

Set additional environment variables:

```bash
azd env set MY_VARIABLE "my-value"
```

Then update `infra/core/appService.bicep` to include the variable in the `appSettings` array.

### Multiple Environments

Create separate environments for dev, staging, and production:

```bash
# Create dev environment
azd init -e dev
azd up -e dev

# Create production environment
azd init -e prod
azd up -e prod
```

### Using a Custom Domain

After deployment, configure a custom domain:

1. Add DNS records for your domain
2. Configure custom domain in App Service
3. Enable managed SSL certificate

See [Azure App Service custom domain documentation](https://learn.microsoft.com/azure/app-service/app-service-web-tutorial-custom-domain).

## Security Best Practices

The infrastructure follows Azure security best practices:

✅ **Managed identities** instead of passwords  
✅ **RBAC** for Container Registry access  
✅ **HTTPS only** enforcement  
✅ **TLS 1.2+** minimum version  
✅ **No secrets in code** - all managed by Azure

## Additional Resources

- [Azure Developer CLI Documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [Azure App Service Documentation](https://learn.microsoft.com/azure/app-service/)
- [Azure Container Registry Documentation](https://learn.microsoft.com/azure/container-registry/)
- [Application Insights Documentation](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)

## Support

For issues or questions:
1. Check the [infra/README.md](infra/README.md) for infrastructure details
2. Review Azure App Service logs
3. Check Application Insights for errors
4. Consult Azure documentation

---

**Happy deploying! 🚀**
