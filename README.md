# reticulous.github.io

The Reticulous website, and the flashmon page it serves. Published by
`.github/workflows/pages.yml` — a GitHub Actions deploy, not "deploy from a
branch", for the reason in **The images** below.

## What the published site is made of

| Path | Comes from | How |
| --- | --- | --- |
| `/`, `/overview/`, … | this repo | Jekyll |
| `/flashmon/` | `spangap/flashmon` | checked out and copied at deploy time |
| `/builds/<catalogue>/` | releases in `reticulous/reticulous` | downloaded at deploy time |

Nothing binary is committed here. Every deploy rebuilds the site from scratch,
so the published site is exactly the sum of those three at that moment.

## Layout

| Path | What it is |
| --- | --- |
| `_config.yml` | Site title, tagline, nav order, permalink style |
| `_layouts/default.html` | The page chrome: header, sidebar, article card, footer |
| `_layouts/doc.html` | Bare skeleton for standalone documents that carry their own CSS |
| `assets/css/site.css` | The whole design, in one file |
| `index.md`, `overview.md`, … | The pages |
| `catalogues` | Which image catalogues the site offers |
| `tools/publish-catalogue.sh` | Uploads a built catalogue and kicks a deploy |

Pages get `layout: default` automatically; only front matter that differs needs
stating. `permalink: pretty` means `overview.md` is served at `/overview/`, which
is what the `nav:` entries in `_config.yml` point at — add a page and its nav
entry together.

The design is shared with [spangap.github.io](https://github.com/spangap/spangap.github.io);
`--brand` in `site.css` is the one token that differs between the two.

## Working on it

Editing a `.md` file and pushing is the whole workflow. To preview the pages
locally:

```sh
bundle install
bundle exec jekyll serve --livereload
```

`Gemfile.lock` is tracked: the deploy runs Jekyll itself rather than handing the
source to GitHub's own pinned copy, so the lock is what makes a deploy match
what you previewed. Commit the one `bundle install` writes.

A local preview has no `/flashmon/` and no `/builds/` — those are laid in by the
deploy. To exercise flashmon locally, use `spangap flashmon` in the workspace,
which serves the page and `builds/local` the way it always has.

## The images

Each catalogue is **one release** in `reticulous/reticulous`, tagged
`catalogue-<name>`, whose assets are the contents of `builds/<name>/` verbatim:
the image zips plus the `index.html`, `timestamp` and `builds.yaml` that
`spangap make-builds` wrote beside them. The release is the durable store; what
the site serves is a snapshot copied in at deploy time.

Publishing a rebuilt catalogue:

```sh
cd <workspace>/builds/stable && spangap make-builds
tools/publish-catalogue.sh stable <workspace>/builds/stable
```

That uploads the directory, deletes assets the rebuild superseded, and fires a
`repository_dispatch` that redeploys the site.

Adding a catalogue means adding its name to `catalogues` and committing — the
deploy publishes what that file lists, and a name removed from it disappears
from the site at the next deploy without touching its release.

### Why the images are copied rather than linked

**A browser cannot fetch a GitHub release asset.** `github.com/…/releases/download/…`
answers a cross-origin request with a 302 carrying no
`access-control-allow-origin`; the signed `release-assets.githubusercontent.com`
URL it redirects to has none either; and the `api.github.com` asset route sends
one on its 302 but not on the redirect target. Every route fails the CORS check
on some hop, so a `fetch()` from the flashmon page is blocked in all three.

Copying the assets into the site at deploy time sidesteps it entirely: the
images end up same-origin with the page that flashes them. That is also what
flashmon already assumes — it reaches its catalogue at the relative
`../builds/<catalogue>/` and builds each image URL from the stamp in that
catalogue's `index.html` — so nothing in `spangap/flashmon` needed changing.

Note the limit this respects and the one it doesn't: a **`fetch()`** must be
same-origin (or CORS-cleared), but a **link the user clicks** is not restricted
at all. Plain download links may point straight at a release asset.

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
`reticulous.net` is committed and the DNS records point at GitHub.

The deploy now carries everything `reticulous.net/flashmon/` serves, so the
cutover moves no path with it. `spangap.org/install.sh` is still on nginx and
still what `building.md` tells people to pipe into a shell; it has to survive
the day `spangap.org` moves.
