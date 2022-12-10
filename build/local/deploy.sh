#! /bin/bash

export IMAGE="reader:latest"
export UI_IMAGE="reader_ui:latest"
export IMAGE_POLICY="Never"
export POSTGRES_LB="---
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
  type: LoadBalancer"
export HOST="localhost"

kubectl create secret generic reader-cert --from-file=tls.key=cert.key --from-file=tls.crt=cert.crt

for f in build/cluster/*.yaml; do envsubst < $f | kubectl apply -f -; done
