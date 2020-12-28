oc project sccexample
token=$(oc rsh ubi8 cat /var/run/secrets/kubernetes.io/serviceaccount/token)
oc  auth can-i --list --token="${token}"
