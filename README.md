<h1>Canary deployment in Kubernetes using Istio</h1>

In the following example, we will use the Istio service mesh to control traffic distribution for a canary deployment using an example application

<h2>Steps to follow</h2>

1. Create or take any application in the container. This time I used "Hello World" on PHP. You will need two containers with different tags.
2. Create a k8s cluster and connect to it. In this task, I used the Google Kubernetes Engine.
3. Install Istio using the Helm (You may need to pre-install the Helm). Currently, you need to run the following commands:

```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.5.1
export PATH=$PWD/bin:$PATH
kubectl create namespace istio-system
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -
kubectl -n istio-system wait --for=condition=complete job --all
helm template install/kubernetes/helm/istio --name istio --namespace istio-system | kubectl apply -f -
```

4. Create two deployments and a common service for them (kubectl apply -f app.yml).
5. Create the sequence: ingress-gateway -> virtual-service -> destination-rule  -> service (kubectl apply -f istio.yml).
6. Find out external IP address istio ingress using command: 

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

## Now you can test your application.

If necessary, you can adjust the auto-scaling of your deployments (kubectl apply -f hpa.yml).

You can also install and use Kubernetes dashboard using the latest instructions from the official documentation. Currently, you need to run the following commands:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f dashboard-adminuser.yaml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

Use command "kubectl proxy" in separate terminal window.
Now you can go to this link:
   http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
and use your token you got earlier.
