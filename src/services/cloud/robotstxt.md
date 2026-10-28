@page Services_Cloud_RobotsTxt Get a fresh robots.txt from the cloud

One free request to the 51Degrees cloud returns a complete robots.txt, with a `Disallow` block for every known crawler whose use you have not allowed. Run it daily and the file picks up new crawlers as we add them.

```
curl -s "https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json?robotstxt.search=allow&robotstxt.tdl=https://m4ow.uk/socw/3.txt" \
  | jq -r .robotstxt.plaintext > robots.txt
```

# Create a free Resource Key

Create a Resource Key at [configure.51degrees.com](https://configure.51degrees.com) with the property `robotstxt.plaintext`. Add `robotstxt.annotatedtext` as well if you want a copy that explains each block. Both are on the free plan.

Leave the key's domain list empty. Your server or build job makes the request, not a browser, and a key limited to domains refuses requests that do not come from one of them.

# Choose the uses you allow

We sort every crawler in our data by what it is used for, such as search or AI training. Send `robotstxt.<use>=allow` for each use you allow. A crawler with any allowed use is let in, and every other crawler we know gets its own `Disallow: /` block.

| Use | What the crawler does |
|-----|-----------------------|
| `search` | Builds search indexes and provides search results |
| `train` | Trains or fine-tunes AI models |
| `input` | Collects content for AI answers and search summaries |
| `index` | Adds content to an AI system's own index |
| `monitor` | Checks that pages respond as expected |
| `archiving` | Archives websites |
| `preview` | Creates link previews |
| `security` | Scans for vulnerabilities |
| `analytics` | Gathers data for marketing analytics |
| `feed` | Aggregates news and data |
| `discovery` | Measures search ranking and discoverability, as SEO tools do |

The full definitions are on the @ref DeviceDetection_Features_Crawlers "Crawlers" page.

Keep `search` in the list unless you want to drop out of search results. A request that allows only `analytics`, for example, blocks Googlebot. A request that allows nothing returns no robots.txt at all.

To let in everything except AI training, AI answers, and AI indexes, send all eight of the other uses.

```
robotstxt.search=allow&robotstxt.monitor=allow&robotstxt.archiving=allow&robotstxt.preview=allow&robotstxt.security=allow&robotstxt.analytics=allow&robotstxt.feed=allow&robotstxt.discovery=allow
```

# Point crawlers at your terms

Send `robotstxt.tdl` with the address of the terms that apply to the crawlers you let in. The last block of the file then carries a Terms Document Locator (TDL) line, which gives crawlers the address of your terms. The comment above it repeats the address.

```
User-Agent: *
# Terms https://m4ow.uk/socw/3.txt
TDL: https://m4ow.uk/socw/3.txt
Allow: /
```

The Movement for an Open Web publishes a free [Search Only Contract](https://m4ow.uk/socw/3.txt). It allows search indexing and human, non-commercial use. Any other use, AI training included, needs a deal with the site. Without one, the crawler's operator owes the site a fee for each article, image, or video, at the amount the site sets in its own terms. The [guide to the contract](https://m4ow.uk/socw/) gives the wording to add to your terms, the fee included.

Link to a version that never changes once published, as in the example, so everyone can see which terms applied on the day. To give more than one address, separate them with commas. Crawlers that do not recognize the TDL line skip it.

# Refresh it on a schedule

Once a day is plenty. That is about 30 of the 10,000 requests a month on the free plan.

This script for Linux and macOS needs `curl` and `jq`.

```sh
#!/bin/sh
# Refreshes robots.txt from the 51Degrees cloud. The current file stays in
# place if the request or the check fails.
set -eu
KEY="YOUR_RESOURCE_KEY"
DEST="/var/www/html/robots.txt"
USES="search monitor archiving preview security analytics feed discovery"
TERMS="https://m4ow.uk/socw/3.txt"

QUERY="robotstxt.tdl=$TERMS"
for USE in $USES; do QUERY="$QUERY&robotstxt.$USE=allow"; done

TMP=$(mktemp "$DEST.XXXXXX")
trap 'rm -f "$TMP"' EXIT
curl -sf "https://cloud.51degrees.com/api/v4/$KEY.json?$QUERY" \
  | jq -er '.robotstxt.plaintext' > "$TMP"
grep -q '^User-Agent: \*' "$TMP"
chmod 644 "$TMP"
mv "$TMP" "$DEST"
```

Run it daily with cron, for example at four in the morning.

```
0 4 * * * /usr/local/bin/refresh-robots.sh
```

On Windows, this PowerShell script does the same, and Task Scheduler can run it daily.

```powershell
# Refreshes robots.txt from the 51Degrees cloud. The current file stays in
# place if the request or the check fails.
$ErrorActionPreference = 'Stop'
$key = 'YOUR_RESOURCE_KEY'
$dest = 'C:\inetpub\wwwroot\robots.txt'
$uses = 'search', 'monitor', 'archiving', 'preview', 'security', 'analytics', 'feed', 'discovery'
$terms = 'https://m4ow.uk/socw/3.txt'

$query = (@("robotstxt.tdl=$terms") + ($uses | ForEach-Object { "robotstxt.$_=allow" })) -join '&'
$file = (Invoke-RestMethod "https://cloud.51degrees.com/api/v4/$key.json?$query").robotstxt.plaintext
if ($file -notmatch '(?m)^User-Agent: \*') { throw 'The response held no robots.txt.' }
[IO.File]::WriteAllText("$dest.new", $file)
Move-Item -Path "$dest.new" -Destination $dest -Force
```

# What the cloud returns

The answer is JSON, and the file is the `plaintext` value in the `robotstxt` element.

```json
{
  "robotstxt": {
    "plaintext": "User-Agent: GPTBot\nDisallow: /\n...",
    "annotatedtext": "..."
  }
}
```

`annotatedtext` is the same file with a comment above each block naming the crawler, its uses, and a link to its operator where we have one. Read it to check your choices, and serve `plaintext`.

# Find out more

- @ref DeviceDetection_Features_RobotsTxt "The robots.txt reference", with every option and the on-premise .NET engine
- @ref DeviceDetection_Features_Crawlers "Crawlers", with the meaning of each use
- The free [robots.txt generator](https://51degrees.com/robots-txt), which emails you the file and sends a fresh one when the list changes
- [Pricing](https://51degrees.com/pricing)
