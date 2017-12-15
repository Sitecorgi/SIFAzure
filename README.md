# SIF Azure Deployments

This module provides functionality to support deployments of Sitecore XP to Azure (PaaS) via the Azure PowerShell toolkit and Sitecore Install Framework (SIF). Alongside the main deployment tasks, there are a couple of additional tasks written to support deployments

## Prerequisites

* Sitecore Install Framework
* PowerShell 5.0  Recommended
* Azure Account with Subscription. If using service principals for auth, it is recommended to also have Azure AD and permission to register applications
* AzureRM.Resources module is installed via Install-Module cmdlet

## Installation

Place the module into the modules directory of your PowerShell installation, typically C:\Program Files\WindowsPowerShell\Modules

## Usage

To use, first populate the supplied JSON configs with your specific parameters (or create your own) and verify the order of the tasks you wish to perform. For more advice around SIF config files, read the installation and configuration guide available at [https://dev.sitecore.net](https://dev.sitecore.net).

The module is called with Install-SitecoreConfiguration, then passing your config in e.g. .\do-all-the-things.json

A number of tasks are supported:

* Deploy a Sitecore instance to Azure using Web Deploy Packages already uploaded
* Creation of a new serivce principal
* Creation of new storage accounts / containers / resource groups
* Uploading new Web Deploy packages to a container as a blob
* 'Uninstallation' via removal of a resource group
* All of the above in order!

Blank azure deployments can therefore be executed via the 'do-all-the-things.json' configuration, which executes the following tasks in order:

1. Log in to Azure via Live account or Service Principal
2. Creation of new resource group
3. Creation of new storage account
4. Creation of new container
5. Uploading both web deploy packages
6. Creation of azure parameters template based on values in configuration params
7. Deployment of configuration to Azure

Deployments typically take between 20-30 minutes to provision in Azure