# Reader

A minimal RSS reader written in OCaml. Inspired by Feedly, but without the bloat.  

## Local Development
Barebones, totally local development environment.  

### Dependencies
 - [central](https://github.com/TheLocust3/central) cloned + running locally
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
Complete the prerequisites found at [Central](https://github.com/TheLocust3/central?tab=readme-ov-file#initial-setup).  
  
Create `database.env` at the root of the repository:
```
PGUSER=jakekinsella
PGPASSWORD=
PGHOST=localhost
PGPORT=5432
PGDATABASE=reader
```

`createdb reader`  
`make install`  
`cd server && make migrate`  

### Run
`cd server && make start`  
`cd server && make puller`  
`cd server && make feed-pruner`  
`cd server && make item-pruner`  
`cd ui && make start`  
  
Navigate to `http://localhost:3000`  

### Other
*Refresh central dependencies:*  
`cd ui && make refresh start`  

## Local Deploy
Complete the prerequisites found at [Central](https://github.com/TheLocust3/central?tab=readme-ov-file#local-deploy).  
  
`eval $(minikube docker-env)`  
`sudo sh -c 'echo "127.0.0.1       reader.localhost" >> /etc/hosts'`
  
### Build+Deploy
`make local-publish`  
`make local-deploy`  
  
Navigate to `https://reader.localhost`  

## Cloud Deploy
Complete the prerequisites found at [Central](https://github.com/TheLocust3/central?tab=readme-ov-file#cloud-deploy).  

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

### Cluster Deploy

Export the Control Plane IP:  
`export CONTROL_PLANE_IP=???`  

Deploy the cluster:  
`make cluster-publish`  
`make cluster-deploy VERSION=???`  

## To-Do
 - Fix intermittent UI delete weirdness where article will be removed from board but remain in the UI until refresh
 - Don't show empty add to board menu
 - Prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
