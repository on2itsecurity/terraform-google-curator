# Basic Curator Deployment

Minimal deployment of an AUXO Curator appliance on GCP with default settings.

## Usage

```bash
# Authenticate with GCP
gcloud auth application-default login

# Deploy
tofu init
tofu apply -var="project_id=YOUR_PROJECT_ID" -var="auth_code=YOUR_AUTH_CODE"
```

## Requirements

| Name                 | Version |
| -------------------- | ------- |
| terraform / opentofu | >= 1.6.0 |
| google               | ~> 6.0  |
