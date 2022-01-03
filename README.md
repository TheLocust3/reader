# reader

`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://astralcodexten.substack.com/feed"}'`  
`curl -XPOST http://localhost:8080/rings/scrape -d'{uri: "https://astralcodexten.substack.com/p/does-georgism-work-is-land-really"}'`  
`curl -XPOST http://localhost:8080/feeds/discover -d'{uri: "https://astralcodexten.substack.com"}'`  
`curl -XPOST http://localhost:8080/feeds/insert -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -XPOST http://localhost:8080/feeds/insert -d'{uri: "https://astralcodexten.substack.com/feed"}'`  
`curl -XPOST http://localhost:8080/users/login -d'{email: "jake.kinsella@gmail.com", password: "password"}'`  

## TODO

### main
 - User JWT
 - Login UI
 - Feedlist management
   - Create/add/remove feeds to user's feedlist
 - "Read watermark"
   - Only return unread items
 - Endpoint to read feed by website URI
   - Pull website, if it's already RSS, return that, otherwise, scrape website for feed

### miscellaneous
 - Run RSS feed scraper periodically
   - How can missing items be avoided?
 - Pipeline: link to RSS feed => RSS feed => Ring from feed =>? links in Ring
   - Dump various outputs in database
 - Proper error handling in feed parsing
   - Not found, invalid RSS, etc
 - Render website with Javascript before parsing

## Notes
 - Feed model
   - indexed by feed source (`.rss`)
   - can be looked up by feed link/name
 - Feed autodiscovery based on website scraping
   - User can manually input RSS feeds
