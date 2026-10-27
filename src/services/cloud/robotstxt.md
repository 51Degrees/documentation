@page Services_Cloud_RobotsTxt Get a fresh robots.txt from the cloud

One request to the 51Degrees cloud returns a complete robots.txt, built from our list of known crawlers and what each one does with content. Run the request on a schedule and your file keeps up as new crawlers appear. AI crawlers stay blocked unless you allow them, and the last lines point every crawler at your terms. It is free.

```
curl -s "https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json?robotstxt.search=allow&robotstxt.tdl=https://m4ow.uk/socw/2.txt" \
  | jq -r .robotstxt.plaintext > robots.txt
```

# Create a free Resource Key

Create a Resource Key at [configure.51degrees.com](https://configure.51degrees.com) with the property `robotstxt.plaintext`. Add `robotstxt.annotatedtext` as well if you want a copy that explains each block. Both are on the free plan.

Leave the key's domain list empty. Your server or build job makes the request, not a browser, and a key limited to domains refuses requests that do not come from one of them.

# Choose the uses you allow

Every crawler in our data is filed under one or more uses, which say what it does with your content. Send `robotstxt.<use>=allow` for each use you allow. A crawler with any allowed use is let in, and every other crawler we know gets its own `Disallow: /` block.

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

Allow `search` unless you want to leave search engines. A request that allows only `analytics`, for example, blocks Googlebot. A request that allows nothing returns no robots.txt at all.

To let in everything except AI training, AI answers, and AI indexes, send all eight of the other uses.

```
robotstxt.search=allow&robotstxt.monitor=allow&robotstxt.archiving=allow&robotstxt.preview=allow&robotstxt.security=allow&robotstxt.analytics=allow&robotstxt.feed=allow&robotstxt.discovery=allow
```

# Point crawlers at your terms

Send `robotstxt.tdl` with the address of the terms that apply to the crawlers you let in. The file then ends with a Terms Document Locator (TDL) line, which tells crawlers where your terms are, and a comment with the same address for people.

```
User-Agent: *
# Terms https://m4ow.uk/socw/2.txt
TDL: https://m4ow.uk/socw/2.txt
Allow: /
```

The Movement for an Open Web publishes a free [Search Only Contract](https://m4ow.uk/socw/2.txt) that any website can adopt. It allows search indexing and human, non-commercial use. Any other use needs a deal, or a fee paid to the site. The [guide to the contract](https://m4ow.uk/socw/) explains the terms.

Link to a version that never changes once published, as in the example, so everyone can see which terms applied on the day. To give more than one address, separate them with commas. Crawlers that do not recognize the TDL line skip it.

# Refresh it on a schedule

The cloud answers from our latest crawler data, so a scheduled request keeps your file current. Once a day is enough, and it uses a small part of the free plan's monthly requests.

This script for Linux and macOS needs `curl` and `jq`. It writes the new file beside the old one and swaps it in only when the request worked and the file looks right, so a failed request leaves your current robots.txt in place.

```sh
#!/bin/sh
# Refreshes robots.txt from the 51Degrees cloud. The current file stays in
# place if the request or the check fails.
set -eu
KEY="YOUR_RESOURCE_KEY"
DEST="/var/www/html/robots.txt"
USES="search monitor archiving preview security analytics feed discovery"
TERMS="https://m4ow.uk/socw/2.txt"

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
$terms = 'https://m4ow.uk/socw/2.txt'

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
