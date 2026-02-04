# Запуск Minikube с CNI с поддержкой Network Policies:

```
minikube start --driver=docker --cni=cilium

```
# Создание namespace

```
kubectl create namespace network-policies-demo

```
# Создание 4 сервисов с метками

```
# 1. front-end
kubectl run front-end-app --image=nginx --labels="role=front-end" -n network-policies-demo
kubectl expose pod front-end-app --port=80 --name=front-end-svc -n network-policies-demo

# 2. back-end-api
kubectl run back-end-api-app --image=nginx --labels="role=back-end-api" -n network-policies-demo
kubectl expose pod back-end-api-app --port=80 --name=back-end-api-svc -n network-policies-demo

# 3. admin-front-end
kubectl run admin-front-end-app --image=nginx --labels="role=admin-front-end" -n network-policies-demo
kubectl expose pod admin-front-end-app --port=80 --name=admin-front-end-svc -n network-policies-demo

# 4. admin-back-end-api
kubectl run admin-back-end-api-app --image=nginx --labels="role=admin-back-end-api" -n network-policies-demo
kubectl expose pod admin-back-end-api-app --port=80 --name=admin-back-end-api-svc -n network-policies-demo

```
# Проверка создания сервисов

```
# все поды запустились
kubectl get pods -n network-policies-demo --show-labels

# сервисы
kubectl get services -n network-policies-demo

```

# Применение сетевых политик

```
# Примените политики 
kubectl apply -f non-admin-api-allow.yaml

# Проверка, что все создано
kubectl get networkpolicies -n network-policies-demo

# Детали
kubectl describe networkpolicies -n network-policies-demo

```