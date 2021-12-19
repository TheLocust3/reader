# reader

`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://hnrss.org/frontpage"}'`  
`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://astralcodexten.substack.com/feed"}'`  
`curl -XPOST http://localhost:8080/rings/scrape -d'{uri: "https://astralcodexten.substack.com/p/does-georgism-work-is-land-really"}'`  
`curl -XPOST http://localhost:8080/feeds/discover -d'{uri: "https://astralcodexten.substack.com"}'`  

## TODO

### main
 - Endpoint to read feed by RSS URI
   - 1) Read from the database, if it exists return that
   - 2) Scrape the feed, return that. In the background, dump it into the database
 - Endpoint to read feed by website URI
   - 1) Read the website => RSS URI mapping from the database, if it exists return that
   - 2) Scrape the website for the feed. In the background, dump it into the database
 - Endpoint to read Ring of feed
   - 1) Read from the database, if it exists return that
   - 2) Scrape the Ring, return that. In the background, dump it into the database

### miscellaneous
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
