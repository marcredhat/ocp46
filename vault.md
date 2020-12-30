
https://medium.com/bb-tutorials-and-thoughts/how-to-pass-hashicorp-vault-associate-certification-c882892d2f2b


https://learn.hashicorp.com/tutorials/vault/certification-vault-associate#study-guide


https://learn.hashicorp.com/tutorials/vault/kubernetes-openshift?in=vault/kubernetes

https://itnext.io/adding-security-layers-to-your-app-on-openshift-update-welcome-vault-agent-injector-46cab161c366


```bash
oc new-project helm

helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault \
    --set "global.openshift=true" \
    --set "server.dev.enabled=true"
```    
    
```text    
The vault-0 pod runs a Vault server in development mode. The vault-agent-injector pod performs the injection based on the annotations present or patched on a deployment.
```

Install Maven as shown at 
https://www.tecmint.com/install-apache-maven-on-centos-7/

```bash
git clone https://github.com/lbroudoux/secured-fruits-catalog-k8s
cd secured-fruits-catalog-k8s
mvn package -Pprod
```


