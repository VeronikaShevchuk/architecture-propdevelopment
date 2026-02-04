echo "=== Применение RoleBindings ==="

# Применяем основные привязки
kubectl apply -f rbac-bindings.yaml

# Создаем аналогичные привязки для других namespace
for ns in dev-tenant dev-finance dev-data; do
  # Developer binding
  kubectl -n $ns create rolebinding developer-binding \
    --role=developer \
    --user=charlie-dev
  
  # Viewer binding
  kubectl -n $ns create rolebinding viewer-binding \
    --role=viewer \
    --user=david-viewer \
    --group=managers
  
  # Namespace admin binding
  kubectl -n $ns create rolebinding namespace-admin-binding \
    --role=namespace-admin \
    --user=alice-devops
done

echo "=== Привязки созданы ==="
kubectl get rolebindings --all-namespaces
kubectl get clusterrolebindings | grep propdev