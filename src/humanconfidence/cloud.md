@page Services_Cloud_HumanConfidence Deploy Human Confidence with the cloud

This guide puts a gate in front of the pages you choose. Before your server sends one of them, it gets Human Confidence for the visitor from the 51Degrees cloud and decides what to send. The worked example gates a retailer's product pages and price API, and the same gate suits a publisher's articles, a listing site's search results, a sign-up form, or any API that serves one person at a time.

You need a holding page, one server file in Node.js, PHP, or Python, and two keys. A @ref Services_Cloud_ResourceKeys "Resource Key" goes in the page, and the License Key from your plan stays on the server. There's no 51Degrees package to install on the server.

If you'd rather see how much of your traffic is people before you change what anyone gets, start with @ref HumanConfidence_Analytics.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

# How it works

1. The first request for a protected page gets a small holding page instead. It runs the 51Degrees script, posts what the script found to your server and reloads. A person sees it for a moment.
2. While the script runs, the browser also answers tests that check it's what it says it is. The cloud judges the answers and gives the page Human Confidence as a sealed value. The browser can carry it, but it can't read or change it. `HumanConfidenceSource` is then Active.
3. Your server sends the sealed value back to the cloud with its License Key, and the cloud gives it the level. This is called redeeming. A sealed value redeems once, within 10 seconds of the check.
4. If there's no sealed value, for example because the tests couldn't run, the server asks the cloud itself. It sends the script's values, the request headers the cloud uses, and the visitor's IP address. The level that comes back is worked out from the request alone, and `HumanConfidenceSource` is Passive.
5. The server caches the level in the session for 30 minutes. It serves the page for High. In the examples Medium goes to a challenge and Low to a page about licensing your data, which you change to suit your site.

The server never takes a level from the browser. A browser can send any level it likes, but it can't make a sealed value the cloud will redeem. This works the same way as checking the creator context of a 51Did (see @ref Identifiers_51Did).

# Step 1. Create a Resource Key

[Create a Resource Key from this link](https://configure.51degrees.com/AQRVdgJ-fPDE5gU130g). It opens with the properties Human Confidence needs already ticked. Check that HumanConfidenceSource is ticked too, and tick it if it isn't. Add the License Key from your plan. A free License Key won't work, because Human Confidence starts at Pro.

Don't add other properties to this key. Some properties carry a script of their own that the holding page has to run, and each of those slows it down.

Leave the domain list empty. The server calls the cloud with the same key, and a server request has no `Origin` header, so a key limited to domains fails with `401` and `This resource key is not authorised for the domain ''`. If you want the limit anyway, send an `Origin` header naming one of your domains on the server's request, for example `Origin: https://www.example.com`.

Only the Resource Key goes in the holding page. The License Key stays on your server, where it redeems the sealed values.

To check the key, open `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` in a browser. You should see something like this.

```json
"derived": {
  "humanconfidence": "Medium",
  "humanconfidencesource": "Passive"
}
```

The level comes from the request alone, so the source is Passive. Opening the address directly runs no script. So the cloud never learns whether the window is in view, and the level is Medium or Low, never High.

# Step 2. Add the holding page

Save this as `holding.html` next to your server code. The server code in step 3 puts the cloud's address in place of `CLOUD_ENDPOINT/` and your Resource Key in place of `RESOURCE_KEY`.

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
    // Send what the 51Degrees script found to the server once, then reload
    // to get the real page.
    var sent = false;
    function check(data) {
      if (sent || !navigator.cookieEnabled) return;
      sent = true;
      var values = new URLSearchParams();
      // The values the script stored, in cookies whose names start 51D_.
      document.cookie.split('; ').forEach(function (cookie) {
        var equals = cookie.indexOf('=');
        if (cookie.indexOf('51D_') === 0) {
          values.append(cookie.slice(0, equals), cookie.slice(equals + 1));
        }
      });
      // When the browser answered the tests, Human Confidence is a sealed
      // value that only your server can redeem. Pass it on as it is.
      var derived = data && data.derived;
      if (derived && derived.humanconfidencesource === 'Active') {
        values.append('humanconfidence', derived.humanconfidence);
        values.append('humanconfidencesource', 'Active');
      }
      fetch('/human-check', { method: 'POST', body: values })
        .then(function () { location.reload(); });
    }
    // Never hold a visitor for more than ten seconds.
    setTimeout(check, 10000);
  </script>
  <!-- Check once the 51Degrees script has finished. If the script cannot
       load, check anyway, and the server decides with what it has. -->
  <script src="CLOUD_ENDPOINT/RESOURCE_KEY.js?fod-js-enable-cookies=true"
          onload="fod.complete(check)" onerror="check()"></script>
</body>
</html>
```

- `fod.complete` calls `check` with the values once the script has finished, the tests included. The tests take a few seconds on a slow device, which is why the page waits up to ten seconds before it gives up and checks without them.
- `fod-js-enable-cookies=true` asks the 51Degrees script to keep its values in cookies with names that start `51D_`. Without the parameter, the script keeps the values in session storage, which your server cannot read. See @ref PipelineApi_Features_ClientSideEvidence for more.
- Post the sealed value as soon as the script finishes. It redeems only within 10 seconds of the check.
- Clients that don't run JavaScript, such as curl, stay on the holding page.

# Step 3. Ask the cloud from your server and decide

1. The server code sends the holding page to any session it has not checked, with `Cache-Control: no-store` so that no cache keeps the holding page.
2. When the holding page posts to `/human-check` with an Active sealed value, the server redeems it. It posts `value`, the sealed value exactly as the page sent it, and `license`, your License Key, to `https://cloud.51degrees.com/api/v4/hc/redeem`. The answer is `{ "humanConfidence": "High" }`, or Medium or Low.
3. When there's no sealed value, or it doesn't redeem, the server asks the cloud itself. It posts a form to `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` with the visitor's headers, every `51D_` value, and the visitor's IP address as `client-ip`. It reads `derived.humanconfidence` from the JSON response.
4. The server caches the level in the session, and logs it with its source. Every later request for a protected page or API uses the cached value.

Things to check when you adapt the code:

- The server sends only the headers the cloud uses, as the 51Degrees SDKs do. Their names are the entries starting `header.` in the list at https://cloud.51degrees.com/api/v4/evidencekeys. Other headers, such as `Authorization`, stay on your server. The Node.js and Python examples read that list on their first check and keep it. The PHP example reads it on every check, because PHP keeps nothing between requests, so cache it if you check often.
- The server sets `client-ip` last. A visitor's own `Client-IP` header can't then replace the address. If your site sits behind a load balancer or a CDN, make sure the address is the visitor's and not the load balancer's. Each example has a comment where this matters.
- Node.js writes IPv4 addresses in the form `::ffff:203.0.113.7`. The Node.js code removes the `::ffff:` part before sending the address.
- The examples call `https://cloud.51degrees.com/api/v4/` unless the `_51DEGREES_CLOUD_ENDPOINT` environment variable names another service, as the 51Degrees examples do. Set it to try the gate against another 51Degrees cloud, such as `https://cloud-staging.51degrees.com/api/v4/`.

What the redeem call can answer:

| Answer | Meaning | What the examples do |
| --- | --- | --- |
| `humanConfidence` of High, Medium, or Low, with `verifiedAt` and `secondsSinceVerified` | The level the cloud worked out when it checked the browser | Use it |
| `result` of `expired`, with `verifiedAt` and `secondsSinceVerified` | Genuine but older than 10 seconds | Ask the cloud for the level from the request alone |
| `result` of `replayed` | Already redeemed on this service instance | The same, because something presented the value twice |
| `result` of `unreadable` | Not a value sealed for your account, or changed | The same. The cloud doesn't say which was wrong |
| `result` of `unconfirmed` (HTTP 503) | The instance couldn't confirm it's the first use | The same, as it's neither a replay nor a forgery |

The record of redeemed values is held in memory on each service instance. So two redemptions of one value that reach two instances can both succeed within the 10 seconds. If your flow must be single use everywhere, keep your own short-lived record of the values you've redeemed.

A page can bind a sealed value to one transaction. Add a `transaction` parameter to the script's address, holding a single-use value your server issued. The server then sends the same value to `hc/redeem`, and the value doesn't redeem without it. The cloud also takes the name `challenge`, as for a 51Did. The examples don't use one.

If the cloud can't be reached, takes longer than 2 seconds to answer a request, or returns an error status, the server lets the visitor through for that page and tries again on the next request. A check that also redeems or reads the evidence key list makes more than one request, each with its own 2 second limit. If the cloud does respond but with Unknown, the visitor gets your challenge (step 4). The example price API only answers sessions that are High, so it refuses calls until a check has worked.

@startsnippets
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Choose a language to see the server code.}
@startsnippet{node}
This uses Express and needs Node.js 18 or later. Save it as `server.mjs` next to `holding.html`, then run these two commands.

```bash
npm install express express-session
RESOURCE_KEY=YOUR_RESOURCE_KEY LICENSE_KEY=YOUR_LICENSE_KEY SESSION_SECRET=any-long-random-text node server.mjs
```

```js
// A Human Confidence gate for Express.
import { readFileSync } from 'node:fs';
import express from 'express';
import session from 'express-session';

// The cloud to call. Set _51DEGREES_CLOUD_ENDPOINT to use another.
const CLOUD = (process.env._51DEGREES_CLOUD_ENDPOINT ||
  'https://cloud.51degrees.com/api/v4/').replace(/\/?$/, '/');
const KEY = process.env.RESOURCE_KEY;
const LICENSE = process.env.LICENSE_KEY; // stays on the server, never in a page
const KEEP_MS = 30 * 60 * 1000; // ask the cloud again after 30 minutes
const TIMEOUT_MS = 2000; // 2 second limit, so a slow cloud cannot hang the website
const HOLDING_PAGE = readFileSync(new URL('holding.html', import.meta.url),
  'utf8').replace('CLOUD_ENDPOINT/', CLOUD).replace('RESOURCE_KEY', KEY);

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

// Redeems the sealed value the page posted. Returns High, Medium or Low, or
// null when the value is expired, already used, or can't be read.
async function redeem(value) {
  try {
    const response = await fetch(CLOUD + 'hc/redeem', {
      method: 'POST',
      body: new URLSearchParams({ value, license: LICENSE }),
      signal: AbortSignal.timeout(TIMEOUT_MS)
    });
    const json = await response.json();
    if (!json.humanConfidence) console.log('Not redeemed:', json.result);
    return json.humanConfidence ?? null;
  } catch (error) {
    console.error('51Degrees redeem:', error.message);
    return null;
  }
}

// Asks the cloud for the level from the request alone. The server asks
// itself, because a level a browser sends could be forged.
async function passiveLevel(req, ip) {
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
  return json.derived?.humanconfidence ?? 'Unknown';
}

const app = express();
// Behind a load balancer or CDN, uncomment this so req.ip is the visitor.
// app.set('trust proxy', 1);
app.use(express.urlencoded({ extended: false }));
app.use(session({
  secret: process.env.SESSION_SECRET, resave: false, saveUninitialized: false
}));

// The holding page posts here. Redeem the sealed value if there is one,
// otherwise ask the cloud, and keep the answer.
app.post('/human-check', async (req, res) => {
  // Node writes IPv4 as ::ffff:a.b.c.d.
  const ip = req.ip.replace(/^::ffff:/, '');
  let answer = null;
  let source = 'Passive';
  if (req.body?.humanconfidencesource === 'Active' && req.body.humanconfidence) {
    answer = await redeem(req.body.humanconfidence);
    if (answer) source = 'Active';
  }
  try {
    answer ??= await passiveLevel(req, ip);
  } catch (error) {
    // The cloud could not answer. Let the visitor through once, and check
    // again on the next request.
    console.error('51Degrees:', error.message);
    req.session.human = { once: true };
    return res.sendStatus(204);
  }
  console.log(`Human Confidence ${answer} (${source})`);
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
RESOURCE_KEY=YOUR_RESOURCE_KEY LICENSE_KEY=YOUR_LICENSE_KEY php -S localhost:3000 index.php
```

```php
<?php
// A Human Confidence gate for PHP.

// The cloud to call. Set _51DEGREES_CLOUD_ENDPOINT to use another.
define('CLOUD', rtrim(getenv('_51DEGREES_CLOUD_ENDPOINT')
    ?: 'https://cloud.51degrees.com/api/v4/', '/') . '/');
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

// Posts a form to the cloud.
function post(string $path, array $form): ?array
{
    return cloud($path, [
        'method' => 'POST',
        'header' => 'Content-Type: application/x-www-form-urlencoded',
        'content' => http_build_query($form),
    ]);
}

// Redeems the sealed value the page posted. Returns High, Medium or Low, or
// null when the value is expired, already used, or can't be read.
function redeem(string $value): ?string
{
    // The License Key stays on the server, never in a page.
    $json = post('hc/redeem', ['value' => $value, 'license' => getenv('LICENSE_KEY')]);
    if ($json !== null && !isset($json['humanConfidence'])) {
        error_log('Not redeemed: ' . ($json['result'] ?? ''));
    }
    return $json['humanConfidence'] ?? null;
}

// Asks the cloud for the level from the request alone. The server asks
// itself, because a level a browser sends could be forged. Returns null if
// the cloud could not answer.
function passive_level(string $ip): ?string
{
    $keys = cloud('evidencekeys');
    if ($keys === null) {
        return null;
    }
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
    $json = post(getenv('RESOURCE_KEY') . '.json', $evidence);
    return $json === null ? null : ($json['derived']['humanconfidence'] ?? 'Unknown');
}

// The holding page posts here. Redeem the sealed value if there is one,
// otherwise ask the cloud, and keep the answer.
function human_check(): void
{
    // Behind a load balancer or CDN, use the visitor's address it passes on,
    // not REMOTE_ADDR.
    $ip = preg_replace('/^::ffff:/', '', $_SERVER['REMOTE_ADDR']);
    $answer = null;
    $source = 'Passive';
    if (($_POST['humanconfidencesource'] ?? '') === 'Active'
        && !empty($_POST['humanconfidence'])) {
        $answer = redeem($_POST['humanconfidence']);
        if ($answer !== null) {
            $source = 'Active';
        }
    }
    $answer ??= passive_level($ip);
    http_response_code(204);
    if ($answer === null) {
        // The cloud could not answer. Let the visitor through once, and check
        // again on the next request.
        $_SESSION['human'] = ['once' => true];
        return;
    }
    error_log("Human Confidence $answer ($source)");
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
        $page = str_replace('CLOUD_ENDPOINT/', CLOUD, $page);
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
RESOURCE_KEY=YOUR_RESOURCE_KEY LICENSE_KEY=YOUR_LICENSE_KEY SECRET_KEY=any-long-random-text python app.py
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

# The cloud to call. Set _51DEGREES_CLOUD_ENDPOINT to use another.
CLOUD = os.environ.get('_51DEGREES_CLOUD_ENDPOINT',
                       'https://cloud.51degrees.com/api/v4/').rstrip('/') + '/'
KEY = os.environ['RESOURCE_KEY']
LICENSE = os.environ['LICENSE_KEY']  # stays on the server, never in a page
KEEP_SECONDS = 30 * 60  # ask the cloud again after 30 minutes
TIMEOUT_SECONDS = 2  # 2 second limit, so a slow cloud cannot hang the website
HOLDING_PAGE = (pathlib.Path(__file__).with_name('holding.html').read_text()
                .replace('CLOUD_ENDPOINT/', CLOUD).replace('RESOURCE_KEY', KEY))
HEADERS = None  # the request headers the cloud uses, read on the first check

app = Flask(__name__)
app.secret_key = os.environ['SECRET_KEY']
# Behind a load balancer or CDN, uncomment these so remote_addr is the visitor.
# from werkzeug.middleware.proxy_fix import ProxyFix
# app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1)


def post(path, form):
    """Posts a form to the cloud and returns the JSON answer."""
    body = urllib.parse.urlencode(form).encode()
    with urllib.request.urlopen(CLOUD + path, body,
                                timeout=TIMEOUT_SECONDS) as response:
        return json.load(response)


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


def redeem(value):
    """Redeems the sealed value the page posted. Returns High, Medium or Low,
    or None when the value is expired, already used, or can't be read."""
    try:
        answer = post('hc/redeem', {'value': value, 'license': LICENSE})
    except (OSError, ValueError) as error:
        app.logger.error('51Degrees redeem: %s', error)
        return None
    if 'humanConfidence' not in answer:
        app.logger.warning('Not redeemed: %s', answer.get('result'))
    return answer.get('humanConfidence')


def passive_level(ip):
    """Asks the cloud for the level from the request alone. The server asks
    itself, because a level a browser sends could be forged."""
    headers = cloud_headers()
    evidence = {name.lower(): value
                for name, value in request.headers.items()
                if name.lower() in headers}
    evidence.update({name: value for name, value in request.form.items()
                     if name.startswith('51D_')})
    evidence['client-ip'] = ip  # set last, so no header can replace it
    derived = post(KEY + '.json', evidence).get('derived', {})
    return derived.get('humanconfidence', 'Unknown')


@app.post('/human-check')
def human_check():
    """The holding page posts here. Redeem the sealed value if there is one,
    otherwise ask the cloud, and keep the answer."""
    ip = request.remote_addr.removeprefix('::ffff:')
    answer = None
    source = 'Passive'
    if (request.form.get('humanconfidencesource') == 'Active'
            and request.form.get('humanconfidence')):
        answer = redeem(request.form['humanconfidence'])
        if answer:
            source = 'Active'
    if answer is None:
        try:
            answer = passive_level(ip)
        except (OSError, ValueError) as error:
            # The cloud could not answer. Let the visitor through once, and
            # check again on the next request.
            app.logger.error('51Degrees: %s', error)
            session['human'] = {'once': True}
            return '', 204
    app.logger.warning('Human Confidence %s (%s)', answer, source)
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

| Value | What it means | Pages | APIs |
| ------ | ------------- | ----- | ---- |
| High | High confidence that a person is reading the page. | Show the page. | Answer the call. |
| Medium | It could be a person or a script. | Challenge with a CAPTCHA, a sign-in, or a notice, [like ours](https://51degrees.com/suspicious). | Refuse with `403` until the visitor passes the challenge. |
| Low | Almost certainly no person is reading it. | Send the visitor to a page that says how to license your content or data, [like ours](https://51degrees.com/ai-notice), and log the visit. | Refuse with `403` and log the call. |
| Unknown | There is insufficient evidence to give a rating. | Treat it as Medium. | Refuse with `403`. |

A Low visit is almost always software, so you can serve it something made for software rather than a page made for people. The examples refuse it, and these are the other treatments websites use, alone or together:

- **The page without what you sell.** A retailer serves the product page without prices and stock, a listing site answers a search with no contact details, and a publisher serves the first paragraph of the article.
- **Content for machines.** Serve the same content as Markdown or plain text instead of HTML, with no navigation, scripts, or ads, so software gets what it came for cheaply and your page for people stays as it is.
- **Your license terms.** Serve the terms the software has to accept to use your content, with a way to get a license. Ours is [the AI notice](https://51degrees.com/ai-notice). The Movement for an Open Web's [Search Only Contract](https://m4ow.uk/socw/3.txt) is a published set of terms any website can adopt, and the [robots.txt generator](https://51degrees.com/robots-txt) writes a robots.txt that cites it.
- **No ads.** Leave the ad slots empty, so nobody pays to show an ad to a script.
- **A block.** Refuse with `403`, as the example API does, and log the visit.

Whatever Low gets, send Medium somewhere a person can prove themselves, and let the search engines you want through by name.

The examples send Medium and Unknown to `/challenge` and Low to `/automated-access`, and the example price API refuses every session that is not High. Replace those two pages with your own. When a visitor passes your challenge, set the cached value to High so they can carry on.

Search engine crawlers get the holding page too, like any session the gate has not checked. If your product pages must appear in search results, let genuine search engine crawlers skip the gate. [Google](https://developers.google.com/crawling/docs/crawlers-fetchers/verify-google-requests) and [Bing](https://www.bing.com/webmasters/help/how-to-verify-bingbot-3905dc26) explain how to check that a crawler really is theirs.

# Test it

Start one of the servers with your keys and try the following. The addresses are the same whichever server you run.

1. Run `curl -i http://localhost:3000/products/1`. You get the holding page. curl runs no JavaScript, so it never gets further.
2. Run `curl -i http://localhost:3000/api/prices/1`. The response is `403 Forbidden`. Nothing has checked the session yet.
3. Open http://localhost:3000/products/1 in your browser. After a few seconds the browser shows the product page or the challenge page. The server logs a line such as `Human Confidence High (Active)`. Active means the browser answered the tests and the server redeemed the sealed value. Passive means it didn't, and the level came from the request alone. When you test on your own computer, expect Medium more often than on a public server.
4. Open the same address in a headless browser, for example with Playwright. The browser reaches `/automated-access`, and the server logs a line that starts `Low:`.

# Find out more

- [Bots and humans](https://51degrees.com/bots-and-humans)
- [How likely is your traffic to be from real humans?](https://51degrees.com/blog/how-to-detect-bot-traffic-and-charge-ai), our post on what each answer means
- [Robots.txt generator](https://51degrees.com/robots-txt)
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)
- @ref Services_Cloud_ResourceKeys
- @ref HumanConfidence_Analytics
- @ref Identifiers_51Did, for the same two-step check applied to a 51Did

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).
