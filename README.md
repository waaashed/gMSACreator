# Créateur de gMSA (Group Managed Service Account) pour Active Directory

![gMSA Image](https://i.postimg.cc/TP7RPQf8/logogmsa.jpg) <!-- Remplace ce lien par une image pertinente pour ton projet -->

Ce projet open source est un créateur de comptes de service gMSA (Group Managed Service Accounts) avec une interface graphique développée en PowerShell. Il est conçu pour faciliter la création et la gestion des comptes de service gMSA directement depuis un contrôleur de domaine.

## Fonctionnalités

- **Création de gMSA :** Crée et configure des comptes gMSA avec des paramètres personnalisables.
- **Interface Graphique :** Interface utilisateur simple et intuitive pour une gestion facile.

## Prérequis

> [!WARNING]
> Le script doit être exécuté sur un contrôleur de domaine.
- **Compte :** Un compte avec des privilèges d'administrateur est nécessaire.

## Comment utiliser

1. **Téléchargement du Script :**

   Télécharge le script PowerShell depuis le dépôt GitHub.

   ```bash
   git clone https://github.com/waaashed/gMSACreator.git

2. **Exécution du Script :**

   Ouvre une fenêtre PowerShell avec les privilèges d'administrateur et exécute le script.

   ```bash
   .\gmsacreator.ps1

2. **Configuration :**

![gMSA2 Image](https://i.postimg.cc/7ZRsYTds/Capture.png)


> Les champs à remplir sont :

- **Nom du compte de service (Name) :** Le nom du compte gMSA à créer.

- **Description :** Une description du compte gMSA.

- **Nom DNS complet (DNSHostName) :** Le FQDN du compte de service.

- **Intervalle de changement de mot de passe (ManagedPasswordIntervalInDays) :** L'intervalle en jours pour le changement automatique du mot de passe, par exemple 30.

- **Principals autorisés à récupérer le mot de passe (PrincipalsAllowedToRetrieveManagedPassword) :** Les entités autorisées à récupérer le mot de passe.

- **Identité de la machine :** L’association permet à cette machine de récupérer et d'utiliser les informations d'identification du compte de service géré.
