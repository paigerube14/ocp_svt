# Login first manually/in browser 
# az login --scope https://management.core.windows.net//.default

az provider register -n Microsoft.RedHatOpenShift --wait      
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Authorization --wait


export LOCATION=eastus                 # the location of your cluster
export CLUSTER=prubenda-aro2             # the name of your cluster
export RESOURCEGROUP=$CLUSTER-rg            # the name of the resource group where you want to create your cluster

az group create --name $RESOURCEGROUP --location $LOCATION

az network vnet create --resource-group $RESOURCEGROUP --name aro-vnet --address-prefixes 10.0.0.0/22

az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name aro-vnet \
  --name master-subnet \
  --address-prefixes 10.0.0.0/23


az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name aro-vnet \
  --name worker-subnet \
  --address-prefixes 10.0.2.0/23

export cluster_info=$CLUSTER_clusterinfo

az aro create \
  --resource-group $RESOURCEGROUP \
  --name $CLUSTER \
  --vnet aro-vnet \
  --master-subnet master-subnet \
  --worker-subnet worker-subnet \
  --pull-secret @"~/pull-secret.txt" >> $cluster_info


az aro list-credentials \              
  --name $CLUSTER \
  --resource-group $RESOURCEGROUP


 az aro show \
    --name $CLUSTER \
    --resource-group $RESOURCEGROUP \
    --query "consoleProfile.url" -o tsv


export KUBEAPI=$(cat $cluster_info | jq -r '.apiserverProfile.url')
export KUBECRED=$(az aro list-credentials --name $CLUSTER --resource-group $RESOURCEGROUP)
export KUBEUSER=$(echo "$KUBECRED" | jq -r '.kubeadminUsername')
export KUBEPASS=$(echo "$KUBECRED" | jq -r '.kubeadminPassword')


oc login "$KUBEAPI" --username="$KUBEUSER" --password="$KUBEPASS"

echo "Generating kubeconfig in ~/.kube/$cluster_info/aro_kubeconfig"

oc config view --raw > ~/.kube/$cluster_info/aro_kubeconfig

# az aro create \
#   --resource-group $RESOURCEGROUP \
#   --name $CLUSTER \
#   --vnet aro-vnet \
#   --master-subnet master-subnet \
#   --worker-subnet worker-subnet \
#   --version <x.y.z>

# https://learn.microsoft.com/en-us/azure/openshift/tutorial-delete-cluster