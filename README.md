# ArgoCD bootsrap

Bootstrap a cluster using argocd.

ArgoCD projects:
- argocd-config - for argocd apps and projects configuration.
- infra - k8s cluster infrastructure.
- services - for service scoped deployments.

## Prerequisites

Have these tools already installed
- ArgoCD CLI
- Kubectl
- Kind
- terraform
- kustomize
- helm

## How to

Create kind cluster:

    kind create cluster --config kind.yaml

Run terraform for the region to bootstrap:

    cd terraform/region1
    terraform init
    terraform plan
    terraform apply -auto-approve

## Access ArgoCD

Since this demo does not include ingress controller, ArgoCD UI access will be made through localhost port-forwarding.

Retrieve ArgoCD admin password:

    argocd admin initial-password -n argocd

Port-forward ArgoCD UI to http://localhost:8080:

    k port-forward svc/argocd-server 8080:80 -n argocd

## Cleanup

    kind delete clusters kind