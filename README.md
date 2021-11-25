# reader

`curl -XPOST http://localhost:8080/feed/read -d'{uri: "https://hnrss.org/frontpage"}'`

## TODO
 - Scrape website for RSS feed
 - Scrape website for links
 - Proper error handling in feed parsing
   - Not found, invalid RSS, etc