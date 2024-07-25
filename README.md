# Créateur & Éditeur de gMSA (Group Managed Service Account) pour Active Directory

![gMSA Image](https://i.postimg.cc/TP7RPQf8/logogmsa.jpg) <!-- Remplacer ce lien par une image pertinente pour le projet -->

Ce projet open source est un créateur et éditeur de comptes de service gMSA (Group Managed Service Accounts) avec une interface graphique développée en PowerShell. Il est conçu pour faciliter la création et la gestion des comptes de service gMSA directement depuis un contrôleur de domaine.

## Fonctionnalités

- **Création de gMSA :** Créer et configurer des comptes gMSA avec des paramètres personnalisables.
- **Interface graphique :** Interface utilisateur simple et intuitive pour une gestion facile.
- **Gestion des Principals :** Interface de gestion des Principals avec des fonctionnalités avancées.

## Prérequis

> [!WARNING]
> Les scripts doivent être exécutés sur un contrôleur de domaine avec un compte d'administrateur à haut privilège.

## Comment utiliser

1. **Téléchargement des Scripts :**

   Téléchargez le script PowerShell depuis le dépôt GitHub.

   ```bash
   git clone https://github.com/waaashed/gMSACreator.git

2. **Exécution des Scripts :**

   Ouvrez une fenêtre PowerShell avec les privilèges d'administrateur pour exécuter les scripts.

   ```bash
   .\gmsacreator.ps1
   ```

   ```bash
   .\gmsaeditor.ps1

2. **Création gMSA (gmsacreator.ps1) :**

![gMSA2 Image](https://i.postimg.cc/7ZRsYTds/Capture.png)


> Les champs à remplir sont :

- **Nom du compte de service (Name) :** Le nom du compte gMSA à créer (L’attribut ne doit pas dépasser 15 caractères).

- **Description :** Une description du compte gMSA.

- **Nom de domaine racine (AD) :** Le FQDN du compte de service sera automatiquement attribué à l'aide du nom du compte de service renseigné précédemment.

- **Intervalle de changement de mot de passe (ManagedPasswordIntervalInDays) :** L'intervalle en jours pour le changement automatique du mot de passe, par exemple 30.

- **Principals autorisés à récupérer le mot de passe (PrincipalsAllowedToRetrieveManagedPassword) :** L'entité ou les entités autorisées à récupérer le mot de passe. 

- **Identité de la machine :** Nom d'une machine autorisée à récupérer et utiliser les informations d'identification du compte de service géré.

> Les gMSA sont créées dans l'OU Managed Service Account : 

![gMSA3 Image](https://i0.wp.com/azurecloudai.blog/wp-content/uploads/2024/01/6acaf-image-38.png)

3. **Gestion PrincipalsAllowedToRetrieveManagedPassword (gmsaeditor.ps1) :**

   ![gMSA4 Image](https://i.postimg.cc/WbbLCyNW/Capture.png)
   

> Les champs à remplir sont :

- **Nom du compte de service (Name) :** Le nom du compte gMSA à gérer.

- **Principal à ajouter :** Ajout d'un PrincipalsAllowedToRetrieveManagedPassword.
  

> Pour supprimer un Principal, sélectionnez-le dans la listebox après avoir renseigné le nom du compte de service.


