@page Services_Cloud_HumanConfidence Deploy Human Confidence with the cloud

This guide puts a gate in front of your product and price pages. Before your server sends one of those pages, it gets Human Confidence for the visitor from the 51Degrees cloud and decides what to send.

You need a holding page, one server file in Node.js, PHP or Python, and a @ref Services_Cloud_ResourceKeys "Resource Key". There's no 51Degrees package to install on the server.

If you'd rather see how much of your traffic is people before you change what anyone gets, start with @ref HumanConfidence_Analytics.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

# How it works

1. The first request for a protected page gets a small holding page instead. It runs the 51Degrees script, posts the script's values to your server and reloads. A person sees it for a moment.
2. Your server sends those values to the cloud along with the request headers the cloud uses and the visitor's IP address. Human Confidence comes back in the response, and the server caches it in the session for 30 minutes.
3. The server serves the page for High. In the examples Medium goes to a challenge and Low to a page about licensing your data, which you change to suit your site. The check is done on the server because anything a browser sends can be forged.

# Step 1. Create a Resource Key

[Create a Resource Key from this link](https://configure.51degrees.com/AQRVdgJ-fPDE5gU130g). It opens with the properties Human Confidence needs already ticked. Add the License Key from your plan. A free License Key won't work, because Human Confidence starts at Pro.

Don't add other properties to this key, as each one adds a script to the holding page and slows it down.

Leave the domain list empty. The server calls the cloud with the same key, and a server request has no `Origin` header, so a key limited to domains fails with `401` and `This resource key is not authorised for the domain ''`. If you want the limit anyway, send an `Origin` header naming one of your domains on the server's request, for example `Origin: https://www.example.com`.

Only the Resource Key goes in the holding page, never the License Key.

To check the key, open `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` in a browser. You should see this. Unknown is right at this point, because the script hasn't run yet.

```json
"derived": {
  "humanconfidence": "Unknown"
}
```

# Step 2. Add the holding page

<!-- Internal note: these code samples move to the examples in the language repositories next week. Replace them with links to those examples then. -->

Save this as `holding.html` next to your server code. The server code in step 3 puts your Resource Key in place of `RESOURCE_KEY`.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="robots" content="noindex">
  <title>One moment</title>
</head>
<body>
  <p>Checking your browser. This needs JavaScript and cookies.</p>
  <script>
    // Send the values the 51Degrees script stored, in cookies whose names
    // start 51D_, to the server once. Then reload to get the real page.
    var sent = false;
    function check() {
      if (sent || !navigator.cookieEnabled) return;
      sent = true;
      var values = new URLSearchParams();
      document.cookie.split('; ').forEach(function (cookie) {
        var equals = cookie.indexOf('=');
        if (cookie.indexOf('51D_') === 0) {
          values.append(cookie.slice(0, equals), cookie.slice(equals + 1));
        }
      });
      fetch('/human-check', { method: 'POST', body: values })
        .then(function () { location.reload(); });
    }
    // Never hold a visitor for more than three seconds.
    setTimeout(check, 3000);
  </script>
  <!-- Check once the 51Degrees script has finished. If the script cannot
       load, check anyway, and the server decides with what it has. -->
  <script src="https://cloud.51degrees.com/api/v4/RESOURCE_KEY.js?fod-js-enable-cookies=true"
          onload="fod.complete(check)" onerror="check()"></script>
</body>
</html>
```

- `fod-js-enable-cookies=true` asks the 51Degrees script to keep its values in cookies with names that start `51D_`. Without the parameter, the script keeps the values in session storage, which your server cannot read. See @ref PipelineApi_Features_ClientSideEvidence for more.
- Clients that don't run JavaScript, such as curl, stay on the holding page.

# Step 3. Ask the cloud from your server and decide

1. The server code sends the holding page to any session it has not checked, with `Cache-Control: no-store` so that no cache keeps the holding page.
2. When the holding page posts to `/human-check`, the server asks the cloud. It posts a form to `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` with the visitor's headers, every `51D_` value, and the visitor's IP address as `client-ip`. It reads `derived.humanconfidence` from the JSON response and caches it in the session.
3. Every later request for a protected page or API uses the cached value.

Things to check when you adapt the code:

- The server sends only the headers the cloud uses, as the 51Degrees SDKs do. Their names are the entries starting `header.` in the list at https://cloud.51degrees.com/api/v4/evidencekeys. Other headers, such as `Authorization`, stay on your server. The Node.js and Python examples read that list on their first check and keep it. The PHP example reads it on every check, because PHP keeps nothing between requests, so cache it if you check often.
- The server sets `client-ip` last. A visitor's own `Client-IP` header can't then replace the address. If your site sits behind a load balancer or a CDN, make sure the address is the visitor's and not the load balancer's. Each example has a comment where this matters.
- Node.js writes IPv4 addresses in the form `::ffff:203.0.113.7`. The Node.js code removes the `::ffff:` part before sending the address.

If the cloud can't be reached, takes longer than 2 seconds or returns an error status, the server lets the visitor through for that page and tries again on the next request. If the cloud does respond but with Unknown, the visitor gets your challenge (step 4). The example price API only answers sessions that are High, so it refuses calls until a check has worked.

<!-- Internal note: these code samples move to the examples in the language repositories next week. Replace them with links to those examples then. -->

@startsnippets
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Choose a language to see the server code.}
@startsnippet{node}
This uses Express and needs Node.js 18 or later. Save it as `server.mjs` next to `holding.html`, then run these two commands.

```bash
npm install express express-session
RESOURCE_KEY=YOUR_RESOURCE_KEY SESSION_SECRET=any-long-random-text node server.mjs
```

```js
// A Human Confidence gate for Express.
import { readFileSync } from 'node:fs';
import express from 'express';
import session from 'express-session';

const CLOUD = 'https://cloud.51degrees.com/api/v4/';
const KEY = process.env.RESOURCE_KEY;
const KEEP_MS = 30 * 60 * 1000; // ask the cloud again after 30 minutes
const TIMEOUT_MS = 2000; // 2 second limit, so a slow cloud cannot hang the website
const HOLDING_PAGE = readFileSync(new URL('holding.html', import.meta.url),
  'utf8').replace('RESOURCE_KEY', KEY);

// The request headers the cloud uses, read on the first check and kept.
// Only these are sent.
let headerNames;
async function cloudHeaders() {
  headerNames ??= new Set((await (await fetch(CLOUD + 'evidencekeys',
    { signal: AbortSignal.timeout(TIMEOUT_MS) })).json())
    .filter((key) => key.startsWith('header.'))
    .map((key) => key.slice(7).toLowerCase()));
  return headerNames;
}

const app = express();
// Behind a load balancer or CDN, uncomment this so req.ip is the visitor.
// app.set('trust proxy', 1);
app.use(express.urlencoded({ extended: false }));
app.use(session({
  secret: process.env.SESSION_SECRET, resave: false, saveUninitialized: false
}));

// The holding page posts the 51D_ values here. Ask the cloud, keep the answer.
app.post('/human-check', async (req, res) => {
  // Node writes IPv4 as ::ffff:a.b.c.d.
  const ip = req.ip.replace(/^::ffff:/, '');
  let answer;
  try {
    const headers = await cloudHeaders();
    const evidence = new URLSearchParams();
    for (const [name, value] of Object.entries(req.headers)) {
      if (headers.has(name)) evidence.set(name, value);
    }
    for (const [name, value] of Object.entries(req.body ?? {})) {
      if (name.startsWith('51D_')) evidence.set(name, value);
    }
    evidence.set('client-ip', ip); // set last, so no header can replace it
    const response = await fetch(CLOUD + KEY + '.json', {
      method: 'POST', body: evidence, signal: AbortSignal.timeout(TIMEOUT_MS)
    });
    const json = await response.json();
    if (!response.ok) throw new Error(JSON.stringify(json.errors));
    answer = json.derived?.humanconfidence ?? 'Unknown';
  } catch (error) {
    // The cloud could not answer. Let the visitor through once, and check
    // again on the next request.
    console.error('51Degrees:', error.message);
    req.session.human = { once: true };
    return res.sendStatus(204);
  }
  if (answer === 'Low') console.log('Low:', ip, req.get('user-agent'));
  req.session.human = { answer, until: Date.now() + KEEP_MS };
  res.sendStatus(204);
});

// Pages for people. Unchecked sessions get the holding page.
function humansOnly(req, res, next) {
  const human = req.session.human;
  if (human?.once) {
    delete req.session.human; // checked again on the next request
    return next();
  }
  if (!human || human.until < Date.now()) {
    res.set('Cache-Control', 'no-store');
    return res.send(HOLDING_PAGE);
  }
  if (human.answer === 'High') return next();
  if (human.answer === 'Low') return res.redirect('/automated-access');
  res.redirect('/challenge'); // Medium or Unknown
}

// APIs answer only sessions the gate has let in.
function humansOnlyApi(req, res, next) {
  const human = req.session.human;
  if (human?.answer === 'High' && human.until > Date.now()) return next();
  res.sendStatus(403);
}

app.get('/products/:id', humansOnly,
  (req, res) => res.send('Product page with prices'));
app.get('/api/prices/:id', humansOnlyApi,
  (req, res) => res.json({ price: 19.99 }));
app.get('/challenge',
  (req, res) => res.send('Your CAPTCHA, sign-in, or notice goes here.'));
app.get('/automated-access', (req, res) => res.send('This page is for ' +
  'people. To use our prices in software, ask us about a data license.'));

app.listen(3000, () => console.log('Open http://localhost:3000/products/1'));
```
@endsnippet
@startsnippet{php}
This needs PHP 8 or later. Save it as `index.php` next to `holding.html`, then run this command to try it with the server built into PHP.

```bash
RESOURCE_KEY=YOUR_RESOURCE_KEY php -S localhost:3000 index.php
```

```php
<?php
// A Human Confidence gate for PHP.
const CLOUD = 'https://cloud.51degrees.com/api/v4/';
const KEEP_SECONDS = 30 * 60; // ask the cloud again after 30 minutes
const TIMEOUT_SECONDS = 2; // 2 second limit, so a slow cloud cannot hang the website

session_start();

// Calls the cloud. Returns the JSON answer, or null if the cloud could not
// answer in time or answered with an error.
function cloud(string $path, array $http = []): ?array
{
    $http['timeout'] = TIMEOUT_SECONDS;
    $body = @file_get_contents(CLOUD . $path, false,
        stream_context_create(['http' => $http]));
    if ($body === false) {
        error_log('51Degrees: ' . (error_get_last()['message'] ?? 'no answer'));
        return null;
    }
    return json_decode($body, true);
}

// The holding page posts the 51D_ values here. Ask the cloud, keep the answer.
function human_check(): void
{
    // Behind a load balancer or CDN, use the visitor's address it passes on,
    // not REMOTE_ADDR.
    $ip = preg_replace('/^::ffff:/', '', $_SERVER['REMOTE_ADDR']);
    $json = null;
    $keys = cloud('evidencekeys');
    if ($keys !== null) {
        // The request headers the cloud uses. Only these are sent.
        $headers = [];
        foreach ($keys as $key) {
            if (str_starts_with($key, 'header.')) {
                $headers[strtolower(substr($key, 7))] = true;
            }
        }
        $evidence = [];
        foreach (getallheaders() as $name => $value) {
            if (isset($headers[strtolower($name)])) {
                $evidence[strtolower($name)] = $value;
            }
        }
        foreach ($_POST as $name => $value) {
            if (str_starts_with($name, '51D_')) {
                $evidence[$name] = $value;
            }
        }
        $evidence['client-ip'] = $ip; // set last, so no header can replace it
        $json = cloud(getenv('RESOURCE_KEY') . '.json', [
            'method' => 'POST',
            'header' => 'Content-Type: application/x-www-form-urlencoded',
            'content' => http_build_query($evidence),
        ]);
    }
    http_response_code(204);
    if ($json === null) {
        // The cloud could not answer. Let the visitor through once, and check
        // again on the next request.
        $_SESSION['human'] = ['once' => true];
        return;
    }
    $answer = $json['derived']['humanconfidence'] ?? 'Unknown';
    if ($answer === 'Low') {
        error_log("Low: $ip " . ($_SERVER['HTTP_USER_AGENT'] ?? ''));
    }
    $_SESSION['human'] = ['answer' => $answer, 'until' => time() + KEEP_SECONDS];
}

// Pages for people. Unchecked sessions get the holding page.
function humans_only(): void
{
    $human = $_SESSION['human'] ?? null;
    if (!empty($human['once'])) {
        unset($_SESSION['human']); // checked again on the next request
        return;
    }
    if ($human === null || $human['until'] < time()) {
        header('Cache-Control: no-store');
        $page = file_get_contents(__DIR__ . '/holding.html');
        echo str_replace('RESOURCE_KEY', getenv('RESOURCE_KEY'), $page);
        exit;
    }
    if ($human['answer'] === 'Low') {
        header('Location: /automated-access');
        exit;
    }
    if ($human['answer'] !== 'High') {
        header('Location: /challenge'); // Medium or Unknown
        exit;
    }
}

// APIs answer only sessions the gate has let in.
function humans_only_api(): void
{
    $human = $_SESSION['human'] ?? null;
    if (($human['answer'] ?? null) !== 'High' || $human['until'] < time()) {
        http_response_code(403);
        exit;
    }
}

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
if ($path === '/human-check' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    human_check();
} elseif (str_starts_with($path, '/products/')) {
    humans_only();
    echo 'Product page with prices';
} elseif (str_starts_with($path, '/api/prices/')) {
    humans_only_api();
    header('Content-Type: application/json');
    echo json_encode(['price' => 19.99]);
} elseif ($path === '/challenge') {
    echo 'Your CAPTCHA, sign-in, or notice goes here.';
} elseif ($path === '/automated-access') {
    echo 'This page is for people. To use our prices in software, '
        . 'ask us about a data license.';
} else {
    http_response_code(404);
}
```
@endsnippet
@startsnippet{python}
This uses Flask and needs Python 3.9 or later. Save it as `app.py` next to `holding.html`, then run these two commands.

```bash
pip install flask
RESOURCE_KEY=YOUR_RESOURCE_KEY SECRET_KEY=any-long-random-text python app.py
```

```python
# A Human Confidence gate for Flask.
import functools
import json
import os
import pathlib
import time
import urllib.parse
import urllib.request

from flask import Flask, abort, redirect, request, session

CLOUD = 'https://cloud.51degrees.com/api/v4/'
KEY = os.environ['RESOURCE_KEY']
KEEP_SECONDS = 30 * 60  # ask the cloud again after 30 minutes
TIMEOUT_SECONDS = 2  # 2 second limit, so a slow cloud cannot hang the website
HOLDING_PAGE = (pathlib.Path(__file__).with_name('holding.html')
                .read_text().replace('RESOURCE_KEY', KEY))
HEADERS = None  # the request headers the cloud uses, read on the first check

app = Flask(__name__)
app.secret_key = os.environ['SECRET_KEY']
# Behind a load balancer or CDN, uncomment these so remote_addr is the visitor.
# from werkzeug.middleware.proxy_fix import ProxyFix
# app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1)


def cloud_headers():
    """The request headers the cloud uses, read once and kept. Only these are
    sent."""
    global HEADERS
    if HEADERS is None:
        with urllib.request.urlopen(CLOUD + 'evidencekeys',
                                    timeout=TIMEOUT_SECONDS) as response:
            HEADERS = {key[7:].lower() for key in json.load(response)
                       if key.startswith('header.')}
    return HEADERS


@app.post('/human-check')
def human_check():
    """The holding page posts the 51D_ values here. Ask the cloud, keep the
    answer."""
    ip = request.remote_addr.removeprefix('::ffff:')
    try:
        headers = cloud_headers()
        evidence = {name.lower(): value
                    for name, value in request.headers.items()
                    if name.lower() in headers}
        evidence.update({name: value for name, value in request.form.items()
                         if name.startswith('51D_')})
        evidence['client-ip'] = ip  # set last, so no header can replace it
        body = urllib.parse.urlencode(evidence).encode()
        with urllib.request.urlopen(CLOUD + KEY + '.json', body,
                                    timeout=TIMEOUT_SECONDS) as response:
            derived = json.load(response).get('derived', {})
        answer = derived.get('humanconfidence', 'Unknown')
    except (OSError, ValueError) as error:
        # The cloud could not answer. Let the visitor through once, and check
        # again on the next request.
        app.logger.error('51Degrees: %s', error)
        session['human'] = {'once': True}
        return '', 204
    if answer == 'Low':
        app.logger.warning('Low: %s %s', ip, request.user_agent)
    session['human'] = {'answer': answer, 'until': time.time() + KEEP_SECONDS}
    return '', 204


def humans_only(view):
    """Pages for people. Unchecked sessions get the holding page."""
    @functools.wraps(view)
    def gated(*args, **kwargs):
        human = session.get('human')
        if human and human.get('once'):
            session.pop('human')  # checked again on the next request
            return view(*args, **kwargs)
        if not human or human['until'] < time.time():
            return HOLDING_PAGE, {'Cache-Control': 'no-store'}
        if human['answer'] == 'High':
            return view(*args, **kwargs)
        if human['answer'] == 'Low':
            return redirect('/automated-access')
        return redirect('/challenge')  # Medium or Unknown
    return gated


def humans_only_api(view):
    """APIs answer only sessions the gate has let in."""
    @functools.wraps(view)
    def gated(*args, **kwargs):
        human = session.get('human')
        if (human and human.get('answer') == 'High'
                and human['until'] > time.time()):
            return view(*args, **kwargs)
        abort(403)
    return gated


@app.get('/products/<id>')
@humans_only
def product(id):
    return 'Product page with prices'


@app.get('/api/prices/<id>')
@humans_only_api
def price(id):
    return {'price': 19.99}


@app.get('/challenge')
def challenge():
    return 'Your CAPTCHA, sign-in, or notice goes here.'


@app.get('/automated-access')
def automated_access():
    return ('This page is for people. To use our prices in software, '
            'ask us about a data license.')


if __name__ == '__main__':
    app.run(port=3000)
```
@endsnippet

# Step 4. Decide what each value gets

| Value | What it means | Product and price pages | Price APIs |
| ------ | ------------- | ----------------------- | ---------- |
| High | A person is reading the page. | Show the page. | Answer the call. |
| Medium | It could be a person or a script. | Challenge with a CAPTCHA, a sign-in, or a notice, [like ours](https://51degrees.com/suspicious). | Refuse with `403` until the visitor passes the challenge. |
| Low | Almost certainly no person is reading it. | Send the visitor to a page that says how to license your price data, [like ours](https://51degrees.com/ai-notice), and log the visit. | Refuse with `403` and log the call. |
| Unknown | Not measured, for example because the script could not run. | Treat it as Medium. | Refuse with `403`. |

The examples send Medium and Unknown to `/challenge` and Low to `/automated-access`, and the example price API refuses every session that is not High. Replace those two pages with your own. When a visitor passes your challenge, set the cached value to High so they can carry on.

Search engine crawlers get the holding page too, like any session the gate has not checked. If your product pages must appear in search results, let genuine search engine crawlers skip the gate. [Google](https://developers.google.com/crawling/docs/crawlers-fetchers/verify-google-requests) and [Bing](https://www.bing.com/webmasters/help/how-to-verify-bingbot-3905dc26) explain how to check that a crawler really is theirs.

# Test it

Start one of the servers with your key and try the following. The addresses are the same whichever server you run.

1. Run `curl -i http://localhost:3000/products/1`. You get the holding page. curl runs no JavaScript, so it never gets further.
2. Run `curl -i http://localhost:3000/api/prices/1`. The response is `403 Forbidden`. Nothing has checked the session yet.
3. Open http://localhost:3000/products/1 in your browser. After a moment the browser shows the challenge page. When you test on your own computer, expect Medium. On a public server, the same browser normally gets High and the product page.
4. Open the same address in a headless browser, for example with Playwright. The browser reaches `/automated-access`, and the server logs a line that starts `Low:`.

# Find out more

- [Bots and humans](https://51degrees.com/bots-and-humans)
- [How likely is your traffic to be from real humans?](https://51degrees.com/blog/how-to-detect-bot-traffic-and-charge-ai), our post on what each answer means
- [Robots.txt generator](https://51degrees.com/robots-txt)
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)
- @ref Services_Cloud_ResourceKeys
- @ref HumanConfidence_Analytics

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).
