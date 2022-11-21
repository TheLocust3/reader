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
 - add read_items table
   - show only unread items in "all"
   - show everything otherwise
 - prune old feed items
 - tighten up UI
   - accent colors
   - less padding, less roundness
 - deploy
 - internal create user endpoint
   - default read later board

### tweaks
 - cascading delete
 - prevent overwriting existing feeds
   - need to normalize feed source urls (so that different forms of URL are equal to eachother)
