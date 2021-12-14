# reader

`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://hnrss.org/frontpage"}'`
`curl -XPOST http://localhost:8080/feeds/read -d'{uri: "https://astralcodexten.substack.com/feed"}'`
`curl -XPOST http://localhost:8080/rings/scrape -d'{uri: "https://astralcodexten.substack.com/p/does-georgism-work-is-land-really"}'`
`curl -XPOST http://localhost:8080/feeds/discover -d'{uri: "https://astralcodexten.substack.com"}'`

## TODO
 - Scrape wesbite for RSS feed
 - Pipeline: link to RSS feed => RSS feed => Ring from feed => RSS feeds from links in Ring
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
