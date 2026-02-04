echo "=== Применение ролей RBAC ==="

# Применяем все роли
kubectl apply -f rbac-roles.yaml

# Создаем те же роли для других namespace
NAMESPACES="dev-tenant dev-finance dev-data"

for ns in $NAMESPACES; do
  # Developer role
  kubectl -n $ns create role developer \
    --verb=get,list,watch,create,update,patch,delete \
    --resource=pods,pods/log,deployments,statefulsets,jobs,cronjobs,services,configmaps \
    --resource=pods/exec --verb=create \
    --resource=events --verb=get,list,watch
  
  # Viewer role
  kubectl -n $ns create role viewer \
    --verb=get,list,watch \
    --resource=pods,deployments,services,configmaps \
    --resource=pods/log --verb=get,list
  
  # Namespace admin role
  kubectl -n $ns create role namespace-admin \
    --verb="*" --resource="*"
done

echo "=== Роли созданы ==="
kubectl get roles --all-namespaces
kubectl get clusterroles | grep propdev