# QR Code Generator

A small ColdFusion site that turns a URL or any text into a QR code image.

Live demo: https://www.trinthlo.com/sites/qrcode

## What it does

- Takes a URL or any text, up to 1,000 characters, and shows it as a 600×600 PNG QR code on the page.
- Encodes text as UTF-8, so accented letters and symbols scan correctly.
- Creates the image in memory with the [ZXing](https://github.com/zxing/zxing) library, so no temporary files are written to the server.
- Puts the text in the page address (`index.cfm?dest=...`), so a link to a particular QR code can be shared or bookmarked.

The 1,000-character limit is lower than the most a QR code can hold. Longer text produces a code so dense that many phone cameras can't read it.

## URL parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `dest` | `https://www.trinthlo.com` | The URL or text to encode |

Example: `index.cfm?dest=https://github.com`

ColdFusion's `scriptProtect` setting is on, so in text containing tags like `<script>` or `<object>`, the tag name is replaced with `InvalidTag` before it's encoded.

## Requirements

- Adobe ColdFusion 2016 or later. It may also run on Lucee, but that hasn't been tested.
- HTTPS. The site redirects every http request to `application.urls.secure`.
- The ZXing jars in `jar/`. `Application.cfc` loads them with `this.javaSettings`, so no ColdFusion Administrator changes are needed.

## Setup

1. Put the folder in your web root, for example `https://localhost/qrcode`.
2. In `Application.cfc`, inside `onApplicationStart`, change `application.urls.normal` and `application.urls.secure` to the address where the site will run (for example `https://localhost/qrcode`). If you skip this step, the https redirect and the page's CSS, JavaScript and images still point to the Trinthlo demo site.
3. Open `index.cfm` in a browser. If you opened the site before changing the URLs, restart ColdFusion first so the new values are loaded.

## Project structure

```
Application.cfc   App settings, ZXing jar loading and SSL redirect
index.cfm         Input checks, QR code creation and the form
layout.cfm        Page layout and footer
jar/              ZXing 3.5.3 (core and javase) and its Apache 2.0 license
assets/           Bootstrap, jQuery, site CSS and images
```

## License

MIT, see [LICENSE](LICENSE). The ZXing jars in `jar/` are covered by the Apache License 2.0, see [jar/LICENSE-ZXING.txt](jar/LICENSE-ZXING.txt).
