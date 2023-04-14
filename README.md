# Reader

A minimal RSS reader written in OCaml. Inspired by Feedly, but without the bloat.  

## Local Development
Barebones, totally local development environment.  

### Dependencies
 - [central](https://github.com/TheLocust3/central) running locally
 - opam
   - `brew install opam`
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)
 - postgres
 - libpq
   - `brew install libpq`
 - openssl
   - `brew install openssl`

### Initial Setup
`initdb data`  
`pg_ctl -D data -l logfile start`  
`createdb reader`  
`make install`  
`cd server && make migrate`  
  
Create `database.env` at the root of the repository:
```
PGUSER=jakekinsella
PGPASSWORD=
PGHOST=localhost
PGPORT=5432
PGDATABASE=reader
```

### Run
`cd server && make start`  
`cd server && make puller`  
`cd server && make feed-pruner`  
`cd server && make item-pruner`  
`cd ui && make start`  
  
Navigate to `http://localhost:3000`  

## Local Deploy
Deployed as a Kubernetes cluster.  

### Dependencies
 - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
 - [minikube](https://minikube.sigs.k8s.io/docs/)
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)

### Initial Setup

`minikube start`  
`eval $(minikube docker-env)`  
`minikube addons enable ingress`  
`minikube tunnel`  
  
Create a certificate called `cert`:
```
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out cert.crt \
            -keyout cert.key
```
  
Create `secrets.env` in the root of the repo:
```
USER_PASSWORD=???
```

### Build+Deploy
`make local-publish`  
`make local-deploy`  

... some amount of waiting ...  
`kubectl get pods` should show the containers starting up  
  
Navigate to `https://localhost`  

## Cloud Deploy
Deploy a single node Kubernetes cluster in AWS.  

### Dependencies
 - [Packer](http://packer.io)
 - [Terraform](https://www.terraform.io)

### Initial Setup

Create `secrets.env` in the root of the repo:
```
USER_PASSWORD=???
```
  
Environment variables:
```
export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???
export AWS_ACCOUNT_ID=???
export AWS_DEFAULT_REGION=us-east-1
```
  
Initialize the build depedencies:  
`make aws-init`

### AWS Setup
Build the AMI:  
`make aws-image`

Set up the ECR repo:  
`make aws-repo`

### AWS Build
Manually create+install an EC2 Key Pair in the AWS Console called "budgeting".  

Build the resources:  
`make aws-build`  
  
Note the value of `control_plane_ip`.  
  
... wait _awhile_ ...  

### Cluster Deploy

Export the Control Plane IP:  
`export CONTROL_PLANE_IP=???`  

Deploy the cluster:  
`make cluster-publish`  
`make cluster-deploy VERSION=???`  

... wait \~10minutes time (until `sudo kubectl get pods` shows all the containers running) ...  

## TODO
 - Puller age-out
 - Add timeout to puller
 - Make buttons/font bigger on iPad
 - Don't show empty add to board menu
 - bump jwt expiry
 - prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
