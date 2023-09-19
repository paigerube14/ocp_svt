# Login first manually/in browser 
# az login --scope https://management.core.windows.net//.default

export LOCATION=eastus                 # the location of your cluster
export CLUSTER=prubenda-aro2            # the name of your cluster
export RESOURCEGROUP=$CLUSTER-rg            # the name of the resource group where you want to create your cluster

az aro delete --resource-group $RESOURCEGROUP --name $CLUSTER