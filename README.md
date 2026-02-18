<div align="center">

# ZavaStorefront Web Application

A FastAPI-based web application (Mergington High School Activities API) with Azure cloud infrastructure provisioning.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/)

</div>

## 📋 Overview

This repository contains a FastAPI application for managing high school extracurricular activities, along with complete Azure infrastructure as code (IaC) for deployment to the cloud.

## 🚀 Quick Deploy to Azure

Deploy the application to Azure with a single command:

```bash
azd up
```

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

### What Gets Deployed

- **Linux App Service** with Docker container support
- **Azure Container Registry** for Docker images (RBAC-authenticated)
- **Application Insights** for monitoring and telemetry
- **Azure AI Services** for GPT-4 and Phi model access
- **Log Analytics** workspace for centralized logging

All resources are deployed to **westus3** in a single resource group for the dev environment.

## 💻 Local Development

### Prerequisites

- Python 3.11 or higher
- pip

### Running Locally

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the application:
   ```bash
   cd src
   uvicorn app:app --reload
   ```

3. Access the application:
   - Web UI: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Alternative docs: http://localhost:8000/redoc

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT.md) - Complete Azure deployment guide
- [Infrastructure Details](infra/README.md) - Bicep templates and architecture
- [API Documentation](src/README.md) - API endpoints and usage

## 🏗️ Project Structure

```
.
├── src/                    # Application source code
│   ├── app.py             # FastAPI application
│   └── static/            # Static web assets
├── infra/                 # Azure infrastructure (Bicep)
│   ├── main.bicep         # Main infrastructure template
│   ├── core/              # Reusable Bicep modules
│   └── README.md          # Infrastructure documentation
├── tests/                 # Test files
├── Dockerfile             # Container definition
├── azure.yaml             # Azure Developer CLI configuration
├── DEPLOYMENT.md          # Deployment guide
└── requirements.txt       # Python dependencies
```

## 🔧 Technology Stack

- **Backend**: FastAPI (Python)
- **Deployment**: Docker, Azure App Service
- **Infrastructure**: Bicep, Azure Developer CLI
- **Monitoring**: Application Insights, Log Analytics
- **AI/ML**: Azure AI Services

## 🔐 Security Features

- Managed Identity for Azure resource access
- RBAC-based Container Registry authentication (no passwords)
- HTTPS-only enforcement
- TLS 1.2+ minimum version
- Secrets managed by Azure Key Vault (optional)

---

<div align="center">

# 🎉 Congratulations AdamSharif-MSFT! 🎉

<img src="https://octodex.github.com/images/welcometocat.png" height="200px" />

### 🌟 You've successfully completed the exercise! 🌟

## 🚀 Share Your Success!

**Show off your new skills and inspire others!**

<a href="https://twitter.com/intent/tweet?text=I%20just%20completed%20the%20%22Getting%20Started%20with%20GitHub%20Copilot%22%20GitHub%20Skills%20hands-on%20exercise!%20%F0%9F%8E%89%0A%0Ahttps%3A%2F%2Fgithub.com%2FAdamSharif-MSFT%2Fskills-getting-started-with-github-copilot%0A%0A%23GitHubSkills%20%23OpenSource%20%23GitHubLearn" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Share%20on%20X-1da1f2?style=for-the-badge&logo=x&logoColor=white" alt="Share on X" />
</a>
<a href="https://bsky.app/intent/compose?text=I%20just%20completed%20the%20%22Getting%20Started%20with%20GitHub%20Copilot%22%20GitHub%20Skills%20hands-on%20exercise!%20%F0%9F%8E%89%0A%0Ahttps%3A%2F%2Fgithub.com%2FAdamSharif-MSFT%2Fskills-getting-started-with-github-copilot%0A%0A%23GitHubSkills%20%23OpenSource%20%23GitHubLearn" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Share%20on%20Bluesky-0085ff?style=for-the-badge&logo=bluesky&logoColor=white" alt="Share on Bluesky" />
</a>
<a href="https://www.linkedin.com/feed/?shareActive=true&text=I%20just%20completed%20the%20%22Getting%20Started%20with%20GitHub%20Copilot%22%20GitHub%20Skills%20hands-on%20exercise!%20%F0%9F%8E%89%0A%0Ahttps%3A%2F%2Fgithub.com%2FAdamSharif-MSFT%2Fskills-getting-started-with-github-copilot%0A%0A%23GitHubSkills%20%23OpenSource%20%23GitHubLearn" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Share%20on%20LinkedIn-0077b5?style=for-the-badge&logo=linkedin&logoColor=white" alt="Share on LinkedIn" />
</a>

### 🎯 What's Next?

**Keep the momentum going!**

[![](https://img.shields.io/badge/Return%20to%20Exercise-%E2%86%92-1f883d?style=for-the-badge&logo=github&labelColor=197935)](https://github.com/AdamSharif-MSFT/skills-getting-started-with-github-copilot/issues/1)
[![GitHub Skills](https://img.shields.io/badge/Explore%20GitHub%20Skills-000000?style=for-the-badge&logo=github&logoColor=white)](https://learn.github.com/skills)

*There's no better way to learn than building things!* 🚀

</div>

---

&copy; 2025 GitHub &bull; [Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/code_of_conduct.md) &bull; [MIT License](https://gh.io/mit)

