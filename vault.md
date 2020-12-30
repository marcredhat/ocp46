
https://medium.com/bb-tutorials-and-thoughts/how-to-pass-hashicorp-vault-associate-certification-c882892d2f2b


https://learn.hashicorp.com/tutorials/vault/certification-vault-associate#study-guide


https://learn.hashicorp.com/tutorials/vault/kubernetes-openshift?in=vault/kubernetes

https://itnext.io/adding-security-layers-to-your-app-on-openshift-update-welcome-vault-agent-injector-46cab161c366

https://developers.redhat.com/blog/2020/06/02/how-the-fabric8-maven-plug-in-deploys-java-applications-to-openshift/

https://maven.fabric8.io/#registry


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

```text
Do NOT grant access directly as in oc adm policy add-scc-to-user anyuid -z my-special-pod

(The above works but challenges have been seen during upgrades as the expected state of the SCC does not match the actual state).

Use OpenShift’s predefined RBAC ClusterRoles

system:openshift:scc:anyuid
system:openshift:scc:hostaccess
system:openshift:scc:hostmount
system:openshift:scc:hostnetwork
system:openshift:scc:nonroot
system:openshift:scc:privileged
system:openshift:scc:restricted

Create new namespace/project
oc new-project sccexample

Create ServiceAccount
oc create sa my-special-pod

Create a ClusterRoleBinding mapping system:openshift:scc:anyuid to our Service Account
oc create -f https://raw.githubusercontent.com/marcredhat/ocp46/main/sccclusterrolebinding.yaml
clusterrolebinding.rbac.authorization.k8s.io/anyuid-scc created


oc run ubi8 --image=registry.redhat.io/ubi8/ubi --serviceaccount=my-special-pod --command -- /bin/bash -c 'while true; do sleep 3; done'

oc get pod -l=run=ubi8 -o jsonpath="{ .items[*].metadata.annotations['openshift\.io/scc'] }"
anyuid
```


```bash
oc adm policy add-scc-to-user anyuid -z default -n fruits-catalog

oc adm policy add-scc-to-user privileged -z default -n fruits-catalog

oc new-app registry.access.redhat.com/rhscl/mongodb-26-rhel7 --name=mongodb -p DATABASE_SERVICE_NAME=mongodb -p MONGODB_ADMIN_PASSWORD=admin -p MONGODB_DATABASE=sampledb -l app=fruits-catalog -n fruits-catalog
```

MONGODB_ADMIN_PASSWORD is required so I modified the Deployment accordingly:

https://raw.githubusercontent.com/marcredhat/ocp46/main/mongodbdeploy.yaml



Check access to OpenShift registry

```bash
[root@vb0636 secured-fruits-catalog-k8s]# sudo podman login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp4.local --tls-verify=false
Login Succeeded!
```

```bash
#mvn fabric8:deploy -Popenshift -Dfabric8.openshift.deployTimeoutSeconds=500 -Ddocker.registry="default-route-openshift-image-registry.apps.ocp4.local"

[root@vb0636 secured-fruits-catalog-k8s]# mvn fabric8:deploy -Popenshift -Dfabric8.openshift.deployTimeoutSeconds=500 -Ddocker.registry="default-route-openshift-image-registry.apps.ocp4.local"
```

```text
...
[INFO] F8: Using OpenShift at https://api.ocp4.local:6443/ in namespace fruits-catalog with manifest /root/secured-fruits-catalog-k8s/target/classes/META-INF/fabric8/openshift.yml
[INFO] OpenShift platform detected
[INFO] F8: Using project: fruits-catalog
[INFO] F8: Using project: fruits-catalog
[INFO] F8: Creating a Service from openshift.yml namespace fruits-catalog name fruits-catalog
[INFO] F8: Created Service: target/fabric8/applyJson/fruits-catalog/service-fruits-catalog.json
[INFO] F8: Using project: fruits-catalog
[INFO] F8: Creating a DeploymentConfig from openshift.yml namespace fruits-catalog name fruits-catalog
[INFO] F8: Created DeploymentConfig: target/fabric8/applyJson/fruits-catalog/deploymentconfig-fruits-catalog.json
[INFO] F8: Using project: fruits-catalog
[INFO] F8: Creating Route fruits-catalog:fruits-catalog host: null
[INFO] F8: HINT: Use the command `oc get pods -w` to watch your pods start up
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 03:09 min
[INFO] Finished at: 2020-12-30T11:11:22-08:00
```

```bash
oc get is
NAME             IMAGE REPOSITORY                                                                       TAGS     UPDATED
fruits-catalog   default-route-openshift-image-registry.apps.ocp4.local/fruits-catalog/fruits-catalog   latest   About a minute ago
mongodb          default-route-openshift-image-registry.apps.ocp4.local/fruits-catalog/mongodb          latest   2 hours ago
```

