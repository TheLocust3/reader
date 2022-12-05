# reader

## setup
Dependencies:
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)
  
  
`make install`  

## local development
`cd server && make start`  
`cd ui && make start`  

## example feeds
 - https://hnrss.org/frontpage?description=0

## todo
 - prune old feed items
 - deploy

### tweaks
 - prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
