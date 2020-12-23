
```bash
[root@vb0634 ocp4_setup_upi_kvm]# cat env
export CLUSTER_NAME="ocp4"
export VIR_NET="default"
export DNS_DIR="/etc/dnsmasq.d"
export VM_DIR="/var/lib/libvirt/images"
export SETUP_DIR="/root/ocp4_setup_ocp4"
export BASE_DOM="local"
export DNS_CMD="restart"
export DNS_SVC="dnsmasq"
export KUBECONFIG="/root/ocp4_setup_ocp4/install_dir/auth/kubeconfig"
```

```bash
[root@vb0634 ocp4_setup_upi_kvm]# /root/ocp4_setup_upi_kvm/.expose_cluster.sh --method haproxy

######################
### HAPROXY CONFIG ###
######################

# haproxy configuration has been saved to: /tmp/haproxy-6vqm.cfg Please review it before applying
# To apply, simply move this config to haproxy. e.g:

      mv '/tmp/haproxy-6vqm.cfg' '/etc/haproxy/haproxy.cfg'

# haproxy can be used to front multiple clusters. If that is the case,
# you only need to merge the 'use_backend' lines and the 'backend' blocks from this confiugration in haproxy.cfg

# You will also need to open the ports (80,443 and 6443) e.g:

      firewall-cmd --add-service=http
      firewall-cmd --add-service=https
      firewall-cmd --add-port=6443/tcp
      firewall-cmd --runtime-to-permanent

# If SELinux is in Enforcing mode, you need to tell it to treat port 6443 as a webport, e.g:

      semanage port -a -t http_port_t -p tcp 6443




[NOTE]: When accessing this cluster from outside make sure that cluster FQDNs resolve from outside

        For basic api/console access, the following /etc/hosts entry should work:

        <IP-of-this-host> api.ocp4.local console-openshift-console.apps.ocp4.local oauth-openshift.apps.ocp4.local
```        
    
```bash
[root@vb0634 ocp4_setup_upi_kvm]# mv '/tmp/haproxy-6vqm.cfg' '/etc/haproxy/haproxy.cfg'
mv: overwrite ‘/etc/haproxy/haproxy.cfg’? y
[root@vb0634 ocp4_setup_upi_kvm]# systemctl restart haproxy
[root@vb0634 ocp4_setup_upi_kvm]# ss -tulpn | grep hapr
udp    UNCONN     0      0         *:55222                 *:*                   users:(("haproxy",pid=454262,fd=6),("haproxy",pid=454261,fd=6))
tcp    LISTEN     0      128       *:6443                  *:*                   users:(("haproxy",pid=454262,fd=5))
tcp    LISTEN     0      128       *:80                    *:*                   users:(("haproxy",pid=454262,fd=8))
tcp    LISTEN     0      128       *:443                   *:*                   users:(("haproxy",pid=454262,fd=7))
```
