# Login first manually/in browser 
export TOKEN=~/.ssh/rosa_perf_token

#https://console.redhat.com/openshift/token/rosa/show

rosa login --env=staging --token=$TOKEN

rosa create account-roles --mode auto -y

export LOCATION=eastus                 # the location of your cluster
export CLUSTER=prubenda            # the name of your cluster
export IDP_USER="rosa-admin"
export IDP_PASSWD="HTPasswd_$(openssl rand -base64 6)"
echo $IDP_PASSWD


rosa create cluster --cluster-name $CLUSTER --sts --mode auto -y

export API_URL=$(rosa describe cluster --cluster $CLUSTER -o json | jq -r '.api.url')
export KUBECRED=$(az aro list-credentials --name $CLUSTER --resource-group $RESOURCEGROUP)
export KUBEUSER=$(echo "$KUBECRED" | jq -r '.kubeadminUsername')
export KUBEPASS=$(echo "$KUBECRED" | jq -r '.kubeadminPassword')

rosa create idp -c ${CLUSTER} \
    --type htpasswd \
    --name rosa-htpasswd \
    --username ${IDP_USER} \
    --password ${IDP_PASSWD}


oc login ${API_URL} -u ${IDP_USER} -p ${IDP_PASSWD} --insecure-skip-tls-verify=true

rosa grant user cluster-admin --user=${IDP_USER} --cluster=${CLUSTER}

echo "Generating kubeconfig in ~/.kube/$CLUSTER/rosa_kubeconfig"
mkdir ~/.kube/$CLUSTER
oc config view --raw > ~/.kube/$CLUSTER/rosa_kubeconfig
