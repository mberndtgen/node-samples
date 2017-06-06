#Install Azure CLI 2.0 according to https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

#Activate your Azure pass according to https://www.microsoftazurepass.com/Home/HowTo
#                               -or-
#Get started with a free trial here: https://azure.microsoft.com/en-us/free/

#Log into Azure
az login

#Define your names and other attributes
RESOURCE_GROUP=pvandorp-node #Fill in your own name
LOCATION=westeurope
APP_SERVICE_PLAN=pvandorp-node-plan #Fill in your own name
APP_SERVICE_PLAN_SKU=S1 
WEB_APP_NAME=pvandorp-node-web #Fill in your own name

#Create a resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

#Create app service plan (this specifies the size of the VM that will be created)
az appservice plan create -g $RESOURCE_GROUP -n $APP_SERVICE_PLAN --sku $APP_SERVICE_PLAN_SKU

#Create app service web app
az webapp create -g $RESOURCE_GROUP -p $APP_SERVICE_PLAN -n $WEB_APP_NAME --runtime "node|6.2"

#Configure a local Git repo and get the URL to the repo
GIT_URL=$(az webapp deployment source config-local-git -g $RESOURCE_GROUP -n $WEB_APP_NAME --query url --output tsv)

#Add a Git remote and name it "azure"
git remote add azure $GIT_URL

#Push master branch to the "azure" remote
git push -u azure master