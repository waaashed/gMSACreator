# 🛠️ gMSA Creator & Editor

<img src="https://i.postimg.cc/TP7RPQf8/logogmsa.jpg" alt="gMSA banner" width="500" />

> **Interface graphique PowerShell** pour créer, modifier et administrer des **Group Managed Service Accounts (gMSA)** dans Active Directory.

[![PowerShell](https://img.shields.io/badge/PowerShell-5%2B-blue.svg)](#prérequis)
[![Dernier commit](https://img.shields.io/github/last-commit/waaashed/gMSACreator)](https://github.com/waaashed/gMSACreator/commits/main)

---

## Table des matières

1. [Fonctionnalités](#fonctionnalités)
2. [Prérequis](#prérequis)
3. [Installation](#installation)
4. [Utilisation rapide](#utilisation-rapide)
   - [Création d'un gMSA](#création-dun-gmsa)
   - [Gestion des Principals](#gestion-des-principals)
5. [Captures d’écran](#captures-décran)
6. [Contribution](#contribution)

---

## Fonctionnalités

- **Création simplifiée** de comptes gMSA avec paramètres personnalisables  
- **Interface graphique moderne** (WinForms/WPF) entièrement en PowerShell  
- **Édition à chaud** des attributs *PrincipalsAllowedToRetrieveManagedPassword*  
- **Validation** en temps réel des champs saisis (longueur, caractères autorisés, etc.)  
- **Journalisation** complète des actions dans le journal d’application Windows  
- **Scripts autonomes** : rien à installer côté client, tout se fait sur le contrôleur de domaine  

---

## Prérequis

> ⚠️ Les scripts **doivent** être exécutés sur un **contrôleur de domaine** avec un compte disposant de droits **Domain Admin** ou équivalents.

| Élément | Version minimale |
| ------- | ---------------- |
| Windows Server | 2012 R2 |
| PowerShell | 5.1 |
| Module **ActiveDirectory** | Installé & importé |
| Niveau fonctionnel du domaine | 2012 R2 |

---

## Installation

Clonez simplement le dépôt :

```bash
git clone https://github.com/waaashed/gMSACreator.git
cd gMSACreator
```

> 💡 **Astuce :** exécutez `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` pour autoriser les scripts le temps de la session.

---

## Utilisation rapide

### Création d'un gMSA

```powershell
# Ouvrir une console PowerShell en mode administrateur
.\gmsacreator.ps1
```

![Creator screenshot](https://i.postimg.cc/7ZRsYTds/Capture.png)

Champs à renseigner :

| Champ | Description |
| ----- | ----------- |
| **Name** | Nom du compte (max : 15 caractères) |
| **Description** | Texte descriptif libre |
| **ManagedPasswordIntervalInDays** | Rotation automatique du mot de passe (par défaut : 30 jours) |
| **PrincipalsAllowedToRetrieveManagedPassword** | Entités autorisées à récupérer le secret |
| **Identité de la machine** | Nom d’hôte d’un serveur autorisé à utiliser le compte |

> 🗂️ Les comptes sont créés dans l’OU **Managed Service Accounts** de votre domaine.

### Gestion des Principals

```powershell
.\gmsaeditor.ps1
```

![Editor screenshot](https://i.postimg.cc/WbbLCyNW/Capture.png)

- Saisissez le **Name** du compte gMSA existant.  
- Utilisez **Add** pour ajouter un principal ou sélectionnez‑le dans la liste et cliquez sur **Remove** pour le supprimer.

---

## Captures d’écran

| Créateur | Éditeur |
| -------- | ------- |
| ![Creator](https://i.postimg.cc/7ZRsYTds/Capture.png) | ![Editor](https://i.postimg.cc/WbbLCyNW/Capture.png) |

---

## Contribution

Les demandes d’amélioration (issues) et *pull requests* sont les bienvenues !  
Si vous souhaitez ajouter une fonctionnalité, ouvrez d’abord une *issue* pour en discuter.

---
