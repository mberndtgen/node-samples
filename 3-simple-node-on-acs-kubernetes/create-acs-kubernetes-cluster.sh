#!/bin/bash

# Set some Environment Variables
RESOURCE_GROUP=node-meetup-acs-demo #Fill in your own name
LOCATION=westeurope
ACS_CLUSTER_NAME=kubernetes-cluster #Fill in your own name
DNS_PREFIX=pvandorp-k8s
ADMIN_USER=pvandorp-demo1
ADMIN_PASSWORD=Welk@m1234

#Generate a SSH key pair for connecting to the ACS cluster
ssh-keygen -t rsa -b 2048 -f ~/.ssh/azure/id_rsa
sudo chown <user>:<user> ~/.ssh/azure/id_rsa

#Create a resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

#Create the Azure Container Service Cluster
az acs create -g $RESOURCE_GROUP -n $ACS_CLUSTER_NAME -d $DNS_PREFIX --admin-username=$ADMIN_USER --admin-password=$ADMIN_PASSWORD --agent-count=3 --location=$LOCATION --master-count=3 --orchestrator-type=kubernetes --ssh-key-value=~/.ssh/azure/id_rsa.pub

#Install kubectl
sudo az acs kubernetes install-cli

#Configure kubectl with the right credentials
az acs kubernetes get-credentials -g $RESOURCE_GROUP -n $ACS_CLUSTER_NAME --ssh-key-file=~/.ssh/azure/id_rsa

#Or...
#scp $ADMIN_USER@$DNS_PREFIX.$LOCATION.cloudapp.azure.com:.kube/config $HOME/.kube/config

#Test kubectl
kubectl cluster-info