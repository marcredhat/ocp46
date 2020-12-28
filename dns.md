
https://rcarrata.com/openshift/dns-deep-dive-in-openshift/


```bash
[root@vb0636 ~]# oc rsh dns-default-5m96b  cat /etc/resolv.conf
Defaulting container name to dns.
Use 'oc describe pod/dns-default-5m96b -n openshift-dns' to see all of the containers in this pod.
search ocp4.local
nameserver 192.168.122.1
```


oc debug -t deployment/customer --image registry.access.redhat.com/rhel7/rhel-tools
