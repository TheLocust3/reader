# reader

## setup
Dependencies:
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)
  
  
`make install`  

## example requests

### /users
`curl -XPOST http://localhost:8080/users/login -d'{email: "jake.kinsella@gmail.com", password: "foobar"}'`  

### /feeds
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -H "authentication: Bearer ${TOKEN}" -XGET http://localhost:8080/feeds/https%3A%2F%2Fhnrss.org%2Ffrontpage`  
`curl -H "authentication: Bearer ${TOKEN}" -XGET http://localhost:8080/feeds/https%3A%2F%2Fastralcodexten.substack.com%2Ffeed`  
`curl -H "authentication: Bearer ${TOKEN}" -XGET http://localhost:8080/feeds/https%3A%2F%2Fhnrss.org%2Ffrontpage/items`

## todo
 - add/remove user feeds through UI
 - add/remove boards through UI
 - auto-logout
 - add item to board
 - add read_items table
   - only show unread items unless asking for all
 - deploy
 - create user endpoint + UI
   - default read later board
 - prevent overwriting existing feeds
   - need to normal feed source urls (so that different forms of URL are equal to eachother)
 - prune old feed items
