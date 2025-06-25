# Déploiement WordPress sur Azure avec Terraform

Ce projet déploie une infrastructure N-tier sur Azure : Web App + ACR + MySQL + Docker personnalisé.

## Étapes

1. Construire l'image Docker :
```bash
docker build -t wordpress-custom docker/
```

2. Se connecter à l'ACR :
```bash
az acr login --name wpacrdev
```

3. Pousser l'image :
```bash
docker tag wordpress-custom wpacrdev.azurecr.io/wordpress-custom:latest
docker push wpacrdev.azurecr.io/wordpress-custom:latest
```

4. Déployer avec Terraform :
```bash
terraform init
terraform apply -var-file="terraform.tfvars"
```

## Prérequis

- Azure CLI
- Terraform
- Docker