
[root@vb0636 helm]# helm version
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
version.BuildInfo{Version:"v3.4.2", GitCommit:"23dd3af5e19a02d4f4baa5b2f242645a1a3af629", GitTreeState:"clean", GoVersion:"go1.14.13"}
[root@vb0636 helm]# oc version
Client Version: 4.6.9
Server Version: 4.6.9
Kubernetes Version: v1.19.0+7070803


helm create buildachart


ls buildachart/
charts  Chart.yaml  templates  values.yaml

