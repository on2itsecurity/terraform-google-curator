# Complete Curator Deployment

Full deployment of an AUXO Curator appliance on GCP with all options configured.

## Usage

```bash
# Authenticate with GCP
gcloud auth application-default login

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Then deploy
tofu init
tofu apply
```

## Requirements

| Name                 | Version |
| -------------------- | ------- |
| terraform / opentofu | >= 1.6.0 |
| google               | ~> 6.0  |
