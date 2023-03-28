#!/bin/bash

echo "$(date) Starting Token Generation"

SERVICE_ACCOUNT_PATH=/var/run/secrets/kubernetes.io/serviceaccount

KUBE_CA_FILE=${KUBE_CA_FILE:-$SERVICE_ACCOUNT_PATH/ca.crt}

TLS_CFG="certificate-authority-data: $(cat $KUBE_CA_FILE | base64 | tr -d '\n')"

SERVICEACCOUNT_TOKEN=$(kubectl -n kube-system create token multus)

MULTUS_KUBECONFIG=/host/etc/cni/net.d/multus.d/multus.kubeconfig

cat > /tmp/multus-temp-conf-eks <<EOF
apiVersion: v1
kind: Config
clusters:
- name: local
  cluster:
    server: ${KUBERNETES_SERVICE_PROTOCOL:-https}://[${KUBERNETES_SERVICE_HOST}]:${KUBERNETES_SERVICE_PORT}
    $TLS_CFG
users:
- name: multus
  user:
    token: "${SERVICEACCOUNT_TOKEN}"
contexts:
- name: multus-context
  context:
    cluster: local
    user: multus
current-context: multus-context
EOF

mv -f /tmp/multus-temp-conf-eks $MULTUS_KUBECONFIG

echo "$(date) Finished Token Generation"