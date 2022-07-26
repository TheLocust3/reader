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
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/discover -d'{uri: "https://astralcodexten.substack.com"}'`  
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/insert -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -H "authentication: Bearer ${TOKEN}" -XPOST http://localhost:8080/feeds/insert -d'{uri: "https://astralcodexten.substack.com/feed"}'`  
`curl -XPOST http://localhost:8080/users/login -d'{email: "jake.kinsella@gmail.com", password: "foobar"}'`  

## todo
 - util package
 - general code cleanup
 - job package
 - kubernetes
