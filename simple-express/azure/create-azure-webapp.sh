#Install Azure CLI 2.0 according to https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

#Log into Azure
az login

RESOURCE_GROUP=pvandorp-node #Fill in your own name
LOCATION=westeurope
APP_SERVICE_PLAN=pvandorp-node-plan #Fill in your own name
APP_SERVICE_PLAN_SKU=S1 
WEB_APP_NAME=pvandorp-node #Fill in your own name

#Create a resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

#Create app service plan (this specifies the size of the VM that will be created)
az appservice plan create -g $RESOURCE_GROUP -n $APP_SERVICE_PLAN --sku $APP_SERVICE_PLAN_SKU

#Create app service web app
az webapp -g $RESOURCE_GROUP -p $APP_SERVICE_PLAN -n $WEB_APP_NAME --runtime "node|6.2" --deployment-local-git

