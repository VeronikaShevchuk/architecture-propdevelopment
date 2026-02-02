echo "=== Инициализация Minikube для PropDevelopment ==="

# Запускаем Minikube
minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=8192 \
  --disk-size=20g \
  --addons=ingress \
  --addons=metrics-server

# Проверяем статус
minikube status

# Создаем namespaces для разных команд
kubectl create namespace dev-sales
kubectl create namespace dev-tenant
kubectl create namespace dev-finance
kubectl create namespace dev-data
kubectl create namespace tenant-services
kubectl create namespace smart-home
kubectl create namespace monitoring

# Метки для namespaces
kubectl label namespace dev-sales team=sales
kubectl label namespace dev-tenant team=tenant
kubectl label namespace dev-finance team=finance
kubectl label namespace dev-data team=data
kubectl label namespace tenant-services app=tenant-services env=prod
kubectl label namespace smart-home app=smart-home env=prod
kubectl label namespace monitoring app=monitoring env=shared

echo "=== Namespaces созданы ==="
kubectl get namespaces --show-labels