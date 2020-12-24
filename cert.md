



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
                
                




    openssl genrsa -out marc-example-ca.key 2048
    openssl req -x509 -new -key marc-example-ca.key -out marc-example-ca.crt -days 1000 -subj "/C=US/ST=NC/L=Chocowinity/O=OS3/OU=Eng/CN=$BASE_DOMAIN"
    openssl genrsa -out marc-example.key 2048
    openssl req -new -key marc-example.key -out marc-example.csr -subj "/C=US/ST=NC/L=Chocowinity/O=OS3/OU=Eng/CN=*.$INGRESS_DOMAIN"
    openssl x509 -req -in marc-example.csr -CA marc-example-ca.crt -CAkey marc-example-ca.key -CAcreateserial -out marc-example.crt -days 1000




2. Configure the CA as the cluster proxy CA:

    oc -n openshift-config create configmap marc-custom-ca --from-file=ca-bundle.crt=marc-example-ca.crt
    oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"marc-custom-ca"}}}'

3. Configure the certificate as the ingresscontroller's default certificate:

    oc -n openshift-ingress create secret tls marc-custom-default-cert --cert=marc-example.crt --key=marc-example.key
    oc -n openshift-ingress-operator patch ingresscontrollers/default --type=merge --patch='{"spec":{"defaultCertificate":{"name":"marc-custom-default-cert"}}}'

    oc -n openshift-config create configmap marc-custom-ca --from-file=ca-bundle.crt=marc-example-ca.crt
        oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"marc-custom-ca"}}}'


  oc -n openshift-config create configmap custom-ca --from-file=ca-bundle.crt=marc-example-ca.crt
            oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'

openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config san.cnf

openssl req -noout -text -in sslcert.csr | grep DNS

```
