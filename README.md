# reticulous.github.io

The Reticulous website. A Jekyll site, built by GitHub Pages straight from the
`main` branch — there is no build step to run and no generated output in the
repo.

## Layout

| Path | What it is |
| --- | --- |
| `_config.yml` | Site title, tagline, nav order, permalink style |
| `_layouts/default.html` | The page chrome: header, sidebar, article card, footer |
| `_layouts/doc.html` | Bare skeleton for standalone documents that carry their own CSS |
| `assets/css/site.css` | The whole design, in one file |
| `index.md`, `overview.md`, … | The pages |

Pages get `layout: default` automatically; only front matter that differs needs
stating. `permalink: pretty` means `overview.md` is served at `/overview/`, which
is what the `nav:` entries in `_config.yml` point at — add a page and its nav
entry together.

## Working on it

Editing a `.md` file and pushing is the whole workflow. To preview locally:

```sh
bundle install
bundle exec jekyll serve --livereload
```

## Publishing a standalone document

A designed HTML document — the kind produced as a Claude artifact — is a
*fragment*: it starts at `<title>` and brings its own `<style>`, but has no
`<!doctype>`, `<html>`, `<head>` or `<body>`. `_layouts/doc.html` supplies
exactly the skeleton such a fragment assumes, and deliberately does not load
`site.css`, so the document's own design is the only one on the page.

Drop the file in and put two lines of front matter at the top:

```
---
layout: doc
title: SUPE
---
```

Front matter switches Liquid on for that file, so a document containing `{{` or
`{%` — template code samples, mostly — needs those spans wrapped in
`{% raw %}` … `{% endraw %}`. A document with no braces needs nothing.

## The domain

The site answers on `reticulous.github.io` until a `CNAME` file naming
`reticulous.net` is committed and the DNS records point at GitHub. Note that
`reticulous.net/flashmon` and `reticulous.net/flashmon/offline-installer/` are
served elsewhere today; both must keep working across any such cutover.
