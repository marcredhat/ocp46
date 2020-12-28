

sudo ssh -i ./.ssh/id_rsa root@vb0636  -L 443:console-openshift-console.apps.ocp4.local:443 -L 443:jenkins-cicd.apps.ocp4.local:443 -L 80:gogs-cicd.apps.ocp4.local:80 -L 80:metrics-app-metrical.apps.ocp4.local:80 -L 80:alertmanager-main-openshift-monitoring.apps.ocp4.local:80 -L 443:thanos-querier-openshift-monitoring.apps.ocp4.local:443
