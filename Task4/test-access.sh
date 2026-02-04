echo "=== Тестирование доступа пользователей ==="

# Функция для тестирования доступа
test_user_access() {
    local user=$1
    local namespace=$2
    local action=$3
    
    echo "Тестирование: $user в $namespace - $action"
    
    kubectl --as=$user --as-group=$user \
      --context=$user-context \
      -n $namespace $action 2>&1 | head -5
    echo "---"
}

# Тест 1: Developer может создавать pod
echo "1. Developer создает pod в dev-sales:"
test_user_access "charlie-dev" "dev-sales" "run test-pod --image=nginx:alpine --restart=Never -- sleep 3600"

# Тест 2: Viewer не может создавать pod
echo "2. Viewer пытается создать pod:"
test_user_access "david-viewer" "dev-sales" "run test-pod --image=nginx:alpine --restart=Never"

# Тест 3: Developer читает pods
echo "3. Developer читает pods:"
test_user_access "charlie-dev" "dev-sales" "get pods"

# Тест 4: Security auditor проверяет secrets
echo "4. Security auditor читает secrets:"
test_user_access "bob-security" "default" "get secrets"

# Тест 5: Smart home operator в своем namespace
echo "5. Smart home operator в namespace smart-home:"
test_user_access "frank-smarthome" "smart-home" "get pods"

# Тест 6: Tenant admin в tenant-services
echo "6. Tenant admin работает с secrets:"
test_user_access "eve-tenant" "tenant-services" "create secret generic test-secret --from-literal=key=value"

# Тест 7: Viewer не может читать secrets
echo "7. Viewer пытается читать secrets:"
test_user_access "david-viewer" "dev-sales" "get secrets"

# Тест 8: Cluster admin полный доступ
echo "8. Cluster admin полный доступ:"
test_user_access "alice-devops" "default" "get nodes"

# Убираем тестовый pod
kubectl -n dev-sales delete pod test-pod --force 2>/dev/null
kubectl -n tenant-services delete secret test-secret --force 2>/dev/null

echo "=== Тестирование завершено ==="