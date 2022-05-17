#!/usr/bin/env bash

set -eo pipefail
set -u

cat <<EOF | kubectl apply -f -
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: benthos-vader
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/window: 6s
        autoscaling.knative.dev/metric: "rps"
        autoscaling.knative.dev/target: "200"
        autoscaling.knative.dev/max-scale: "10"
    spec:
      containers:
        - image: mihaitodor/benthos-vader:latest
          args: [ "-c", "/opt/benthos/benthos.yaml" ]
          ports:
            - containerPort: 4195
          volumeMounts:
            - name: config-volume
              mountPath: /opt/benthos
      volumes:
        - name: config-volume
          configMap:
            name: benthos-vader-config
EOF

echo "Downloading benthos-vader app container image..."
kubectl wait ksvc benthos-vader --all --timeout=-1s --for=condition=Ready > /dev/null
SERVICE_URL=$(kubectl get ksvc benthos-vader -o jsonpath='{.status.url}')
echo "The Knative Service benthos-vader endpoint is $SERVICE_URL"
curl -v $SERVICE_URL/ping
