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
export HOST="reader.cluster.local"
export CENTRAL_BASE="http://central-server:8080/api"

for f in build/cluster/*.yaml; do envsubst < $f | kubectl apply -f -; done
