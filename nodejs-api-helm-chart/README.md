# Helm Chart Installation Guide For MongoDB and Node.js CRUD API

This guide explains how to deploy MongoDB as a database and a Node.js CRUD API using Helm charts.

## Prerequisites

Before you begin, ensure you have the following:

1. **Kubernetes Cluster**: A running Kubernetes cluster (v1.20+ recommended).
2. **kubectl**: Installed and configured to access your Kubernetes cluster.
3. **Helm**: Version 3 or later installed on your local machine.

## Steps to Deploy MongoDB and Node.js CRUD API

### 1. Add Helm Repositories

Add the mongodb Helm chart repositories:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 2. Install MongoDB Helm Chart

```bash
helm install mongodb bitnami/mongodb \
  --namespace mongodb \
  --create-namespace \
  --set auth.rootPassword=your-root-password \
  --set auth.username=your-username \
  --set auth.password=your-password\
  --set auth.database=your-database \
  --set persistence.storageClass=gp2 \
  --set persistence.size=8Gi \
  --set replicaSet.enabled=true
```

Replace:
- `your-root-password` with the desired MongoDB root password.
- `your-username` with the desired MongoDB user.
- `your-password` with the desired password for the user.
- `your-database` with the desired MongoDB database name.

### 3. Verify MongoDB Installation

Check that the MongoDB deployment is running:

```bash
kubectl get pods -n mongodb
```

Obtain the MongoDB service details:

```bash
kubectl get svc -n mongodb
```

### 4. Update the secrets.yaml and values.yaml file

Update the secrets.yaml file

```bash
stringData:
  DB_USER: <your-username>
  DB_PASSWORD: <your-password>
```

Update the values.yaml file

```bash
env:
  DB_HOST: mongodb.mongodb.svc.cluster.local
  DB_PORT: 27017
  DB_NAME: <your-database>
ingress:
  enabled: true
  ingressClass: alb
  annotations: 
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/load-balancer-name: <load-balancer-name>
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
    alb.ingress.kubernetes.io/subnets: <subnet ID's>
  hosts:
    - host:
      paths:
        - path: /api/products
          pathType: Prefix
```
Replace:
- `your-database` with the desired MongoDB database name.
- `subnet ID's` with the desired subnet ID's
- `load-balancer-name` with the desired load balancer name

### 5. Create the k8s nodejs-api namespace and Deploy the Node.js CRUD API Helm Chart

```bash
kubectl create ns nodejs-api
helm install nodejs-api .  -n nodeja-api
```

### 6. Verify Node.js CRUD API Deployment

Check that the Node.js CRUD API pods are running:

```bash
kubectl get pods -n nodejs-api
```

Get the Node.js API service details:

```bash
kubectl get svc -n nodejs-api
```

### 6. Test the API

1. **Node.js API**:
   Test the API endpoints using tools like `curl` or Postman:

   ```bash
   curl http://<nodejs-load-balancer-dns>/api/products
   ```

Replace `<nodejs-load-balancer-dns>` value from the Node.js Application Load Balancer.

### 7. Install kube-prometheus stack for monitoring 

Add the kube-prometheus-stack helm chart repositories which setup prometheus for monitoring, alertmanager for alerting and grafana to visualize:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
```

### 8. Cleanup

To remove the deployment, run the following commands:

```bash
helm uninstall mongodb -n mongodb
helm uninstall nodejs-api -n nodejs-api
helm uninstall kube-prometheus-stack -n monitoring
kubectl delete namespace mongodb nodejs-api monitoring
```

---
