echo "=== Создание пользователей PropDevelopment ==="

# Создаем директорию для сертификатов
mkdir -p ~/k8s-users && cd ~/k8s-users

# Генерируем приватный ключ для CA (если нет)
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=Kubernetes-CA" -days 3650 -out ca.crt

# Функция для создания пользователя
create_user() {
    local username=$1
    local group=$2
    
    echo "Создание пользователя: $username (группа: $group)"
    
    # Генерируем приватный ключ пользователя
    openssl genrsa -out $username.key 2048
    
    # Создаем CSR
    openssl req -new -key $username.key \
      -subj "/CN=$username/O=$group" \
      -out $username.csr
    
    # Подписываем сертификат CA
    openssl x509 -req -in $username.csr \
      -CA ca.crt -CAkey ca.key -CAcreateserial \
      -out $username.crt -days 365
    
    # Создаем kubeconfig для пользователя
    kubectl config set-credentials $username \
      --client-certificate=$username.crt \
      --client-key=$username.key \
      --embed-certs=true
    
    kubectl config set-context $username-context \
      --cluster=minikube \
      --namespace=default \
      --user=$username
}

# Создаем пользователей для разных ролей
create_user "alice-devops" "devops"
create_user "bob-security" "security"
create_user "charlie-dev" "developers"
create_user "david-viewer" "viewers"
create_user "eve-tenant" "tenant-admin"
create_user "frank-smarthome" "smart-home-ops"
create_user "grace-manager" "managers"

echo "=== Пользователи созданы ==="
ls -la *.crt