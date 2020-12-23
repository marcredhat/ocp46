## Configure authentication with htpasswd

```bash
htpasswd -c -B -b users.htpasswd marc '<password>'
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
```

```bash
cat <<EOF > htpasswd-conf.yml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: quicklab_htpasswd
    mappingMethod: claim
    type: HTPasswd
    htpasswd:
      fileData:
        name: htpass-secret
EOF
```

```bash
oc apply -f htpasswd-conf.yml
```

```bash
oc adm policy add-cluster-role-to-user cluster-admin marc
```
