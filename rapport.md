# Rapport Technique

## Choix techniques
- Utilisation de Terraform pour l'Infra-as-Code.
- Web App Azure avec Docker personnalisé basé sur WordPress.
- MySQL Flexible Server pour la base de données.
- ACR pour stocker l’image Docker.

## Problèmes rencontrés
- Accès réseau entre Web App et MySQL résolu via les paramètres d'environnement.
- Nécessité d’utiliser un SKU compatible pour la Web App avec un conteneur.