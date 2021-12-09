# reader

`curl -XPOST http://localhost:8080/feed/read -d'{uri: "https://hnrss.org/frontpage"}'`
`curl -XPOST http://localhost:8080/feed/read -d'{uri: "https://astralcodexten.substack.com/feed"}'`
`curl -XPOST http://localhost:8080/ring/scrape -d'{uri: "https://astralcodexten.substack.com/p/does-georgism-work-is-land-really"}'`

## TODO
 - Scrape website for RSS feed
   - Scrape only links from RSS feeds
 - Scrape website for links
 - Proper error handling in feed parsing
   - Not found, invalid RSS, etc
 - Render website with Javascript before parsing