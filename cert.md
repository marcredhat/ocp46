

Based on https://fabianlee.org/2018/02/17/ubuntu-creating-a-trusted-ca-and-san-certificate-using-openssl-on-ubuntu/

```bash

cd ocp4
export KUBECONFIG=install_dir/auth/kubeconfig
cp ./oc /usr/bin
BASE_DOMAIN="$(oc get dns.config/cluster -o 'jsonpath={.spec.baseDomain}')"


INGRESS_DOMAIN="$(oc get ingress.config/cluster -o 'jsonpath={.spec.domain}')"


echo $BASE_DOMAIN
ocp4.local
echo $INGRESS_DOMAIN
apps.ocp4.local




export prefix="ocp4.local"

[root@vb0634 certs]# cp /etc/pki/tls/openssl.cnf $prefix.cnf
[root@vb0634 certs]# ls
ocp4.local.cnf



openssl genrsa -aes256 -out ca.key.pem 2048

chmod 400 ca.key.pem

[root@vb0634 certs]# ls
ca.key.pem  ocp4.local.cnf


[root@vb0634 certs]# openssl req -new -x509 -subj "/CN=myca" -extensions v3_ca -days 3650 -key ca.key.pem -sha256 -out ca.pem -config $prefix.cnf
Enter pass phrase for ca.key.pem:
[root@vb0634 certs]# ls
ca.key.pem  ca.pem  ocp4.local.cnf
[root@vb0634 certs]#


[root@vb0634 certs]# openssl x509 -in ca.pem -text -noout | grep CA:TRUE
                CA:TRUE
                

[root@vb0634 certs]# openssl genrsa -out $prefix.key.pem 2048
Generating RSA private key, 2048 bit long modulus
........+++
.....................................................+++
e is 65537 (0x10001)
[root@vb0634 certs]# ls
ca.key.pem  ca.pem  ocp4.local.cnf  ocp4.local.key.pem

[root@vb0634 certs]# openssl req -subj "/CN=$prefix" -extensions v3_req -sha256 -new -key $prefix.key.pem -out $prefix.csr
[root@vb0634 certs]# ls
ca.key.pem  ca.pem  ocp4.local.cnf  ocp4.local.csr  ocp4.local.key.pem


[root@vb0634 certs]# openssl x509 -req -extensions v3_req -days 3650 -sha256 -in $prefix.csr -CA ca.pem -CAkey ca.key.pem -CAcreateserial -out $prefix.crt -extfile $prefix.cnf
Signature ok
subject=/CN=ocp4.local
Getting CA Private Key
Enter pass phrase for ca.key.pem:
[root@vb0634 certs]# ls
ca.key.pem  ca.pem  ca.srl  ocp4.local.cnf  ocp4.local.crt  ocp4.local.csr  ocp4.local.key.pem
[root@vb0634 certs]#



openssl x509 -in $prefix.crt -text -noout

Servers like HAProxy want the full chain of certs along with private key (server certificate+CA cert+server private key).  While Windows IIS wants a .pfx file.  Here is how you would generate those files.

cat $prefix.crt ca.pem $prefix.key.pem > $prefix-ca-full.pem

openssl pkcs12 -export -out $prefix.pfx -inkey $prefix.key.pem -in $prefix.crt -certfile ca.pem

[root@vb0634 certs]# ls
ca.key.pem  ca.pem  ca.srl  ocp4.local.cnf  ocp4.local.crt  ocp4.local.csr  ocp4.local.key.pem

Configure the CA as the cluster proxy CA:

[root@vb0634 certs]#  oc -n openshift-config create configmap marc-custom-ca --from-file=ca-bundle.crt=ca.pem
configmap/marc-custom-ca created
[root@vb0634 certs]#     oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"marc-custom-ca"}}}'
proxy.config.openshift.io/cluster patched


Configure the certificate as the ingresscontroller's default certificate:

[root@vb0634 certs]# openssl rsa -in ca.key.pem -out ca.key.pem.unencrypted
Enter pass phrase for ca.key.pem:
writing RSA key

[root@vb0634 certs]#  oc -n openshift-ingress create secret tls marc-custom-default-cert --cert=ca.pem --key=ca.key.pem.unencrypted
secret/marc-custom-default-cert created

    oc -n openshift-ingress-operator patch ingresscontrollers/default --type=merge --patch='{"spec":{"defaultCertificate":{"name":"marc-custom-default-cert"}}}'

    oc -n openshift-config create configmap marc-custom-ca --from-file=ca-bundle.crt=marc-example-ca.crt
        oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"marc-custom-ca"}}}'


  oc -n openshift-config create configmap custom-ca --from-file=ca-bundle.crt=marc-example-ca.crt
            oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'

openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config san.cnf

openssl req -noout -text -in sslcert.csr | grep DNS

```
