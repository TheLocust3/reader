# reader

## setup
Dependencies:
 - [dune](https://dune.build)
 - [yarn](https://yarnpkg.com)
  
  
`make install`
`make start`

## example requests

`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/read -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/read -d'{uri: "https://astralcodexten.substack.com/feed"}'`    
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/add -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/add -d'{uri: "https://astralcodexten.substack.com/feed"}'`  
`curl -XPOST http://localhost:8080/users/login -d'{email: "jake.kinsella@gmail.com", password: "foobar"}'`  

## todo
 - recover on error for routes
 - consistent error handling for routes
 - add more specific models
   - database/source/frontend variants
 - create user endpoint
 - pull items from feeds on interval
   - add "refreshed_at" field to feeds, use to drive pulling
   - need to dedupe feed items
 - add lists to aggregate feeds
   - pull items by list
   - attached to user
 - add read_items table
   - only show unread items unless asking for all
