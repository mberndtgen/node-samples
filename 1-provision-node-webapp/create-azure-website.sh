#!/bin/bash

#Install Azure CLI 2.0 according to https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

#Activate your Azure pass according to https://www.microsoftazurepass.com/Home/HowTo
#                               -or-
#Get started with a free trial here: https://azure.microsoft.com/en-us/free/

#Log into Azure
az login

#Define your names and other attributes
RESOURCE_GROUP=rg_mb_nodetest1 #Fill in your own name
LOCATION=westeurope #Azure DC Amsterdam
APP_SERVICE_PLAN=asp_mb_plantest1 #Fill in your own name
APP_SERVICE_PLAN_SKU=S1 
WEB_APP_NAME=web-mb-test1 #Fill in your own name (DNS!, no underscores)
DEPLOYMENT_USER=mbtest1
DEPLOYMENT_PASSWORD=*******

#Create a resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

#Create app service plan (this specifies the size of the VM that will be created)
az appservice plan create -g $RESOURCE_GROUP -n $APP_SERVICE_PLAN --sku $APP_SERVICE_PLAN_SKU

#Create app service web app
az webapp create -g $RESOURCE_GROUP -p $APP_SERVICE_PLAN -n $WEB_APP_NAME --runtime "node|6.10"

# website name will be web-mb-test1.azurewebsites.net

# list all current runtimes
# az webapp list-runtimes

#Set the deployment credentials
az webapp deployment user set --user-name $DEPLOYMENT_USER --password $DEPLOYMENT_PASSWORD

#Configure a local Git repo and get the URL to the repo
GIT_URL=$(az webapp deployment source config-local-git -g $RESOURCE_GROUP -n $WEB_APP_NAME --query url --output tsv)


#Install Express Generator (https://expressjs.com/en/starter/generator.html)
npm install -g express-generator

#Generate a simple Express Web Application
express --pug --view pug --css less --git ../$WEB_APP_NAME
cd ../$WEB_APP_NAME

#Do the Git routine
git init
git add .
git commit -m "initial commit"

#Add a Git remote and name it "azure"
git remote add azure $GIT_URL

#Push master branch to the "azure" remote
git push -u azure master

