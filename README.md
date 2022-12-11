# reader

## local development

### dependecies
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)
 - postgres
 - libpq

### initial setup
`initdb data`  
`pg_ctl -D data -l logfile start`  
`createdb reader`  
`make install`  
`cd server && make migrate`  
  
Create `secrets.env` at the root of the repository:
```
PGUSER=jakekinsella
PGPASSWORD=
PGHOST=localhost
PGPORT=5432
PGDATABASE=reader
```

### run
`cd server && make start`  
`cd server && make puller`  
`cd server && make feed-pruner`  
`cd server && make item-pruner`  
`cd ui && make start`  
  
Navigate to `http://localhost:3000`  

## local deploy

### dependecies
 - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
 - [minikube](https://minikube.sigs.k8s.io/docs/)
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)

### initial setup

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

### build+deploy
`make local-publish`
`make local-deploy`

... some amount of waiting ...  
`kubectl get pods` should show the containers starting up  
  
Navigate to `http://localhost:3000`  

## cloud deploy
TODO  

## example feeds
 - https://hnrss.org/frontpage?description=0
 - https://astralcodexten.substack.com/feed

## todo
 - deploy
   - deploy to AWS
 - optimize for iPad

### tweaks
 - Don't show empty add to board menu
 - bump jwt expiry
 - prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
