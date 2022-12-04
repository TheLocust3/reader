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
 - https://hnrss.org/frontpage

## todo
 - prune old feed items
 - deploy
 - internal create user endpoint
   - default read later board

### tweaks
 - cascading delete
 - prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
