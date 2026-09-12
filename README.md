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

No build output is committed here — the only binaries in the repo are the
screenshots in `assets/img/`, which are site content. Every deploy rebuilds the
site from scratch, so the published site is exactly the sum of those three at
that moment.

## Layout

| Path | What it is |
| --- | --- |
| `_config.yml` | Site title, tagline, nav order, permalink style |
| `_layouts/default.html` | The page chrome: header, sidebar, article card, footer |
| `_layouts/doc.html` | Bare skeleton for standalone documents that carry their own CSS |
| `assets/css/site.css` | The whole design, in one file |
| `assets/img/` | Screenshots the pages show |
| `index.md`, `overview.md`, … | The pages |
| `catalogues` | Which image catalogues the site offers |

Pages get `layout: default` automatically; only front matter that differs needs
stating. `permalink: pretty` means `overview.md` is served at `/overview/`, which
is what the `nav:` entries in `_config.yml` point at — add a page and its nav
entry together.

The design is shared with [spangap.github.io](https://github.com/spangap/spangap.github.io);
`site.css` and `_layouts/` are identical in the two repos and `--brand` is the
one token that differs, so a change to either belongs in both.

A screenshot goes in as a `figure.shot` whose image is wrapped in a button —
`default.html` carries one overlay and a delegating click handler, so that
markup is the whole of it and clicking the shot enlarges it (click anywhere, or
Esc, to dismiss):

```html
<figure class="shot">
<button type="button"><img src="{{ '/assets/img/web-ui.png' | relative_url }}" width="3200" height="2400" alt="…"></button>
<figcaption>…</figcaption>
</figure>
```

State the file's real pixel dimensions in `width`/`height` — the CSS scales it
to the column, and the attributes keep the page from reflowing as it loads.

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

Publishing is **`<workspace>/builds/deploy-builds`**, run on the host — one
script for the whole tree, not one invocation per catalogue:

```sh
cd <workspace>/builds/stable && spangap make-builds
cd <workspace>/builds && ./deploy-builds            # or --dry-run first
```

It walks every directory here holding a `builds.yaml`, brings its release into
line with what the directory holds, and fires one `repository_dispatch` at the
end if anything moved. Assets the directory no longer carries are deleted, which
is what retires a superseded image: a new build lands under a new stamp and
never overwrites its predecessor.

What counts as changed differs by kind. An image is settled by its name and
size, since the stamp in a zip's name is unique to the build inside it.
`index.html`, `timestamp` and `builds.yaml` are rewritten in place by every
`spangap make-builds` and keep both their names and, as a rule, their sizes — a
stamp is fixed-width, and an index listing the same images under new stamps is
the same length it was — so the release's own copies are fetched and compared
byte for byte.

Two catalogues are held back from a bare run: `builds/local`, which is whatever
this machine last compiled, and any directory carrying a `.nodeploy` marker.
Naming a catalogue on the command line (`./deploy-builds rop`) publishes it
regardless — asking for it by name is the deliberate act the marker exists to
require.

Adding a catalogue means adding its name to `catalogues` and committing — the
deploy publishes what that file lists, and a name removed from it disappears
from the site at the next deploy without touching its release. `deploy-builds`
warns when it publishes a catalogue this file does not name, since the symptom
otherwise is a catalogue that simply never appears.

A catalogue carrying a **`.unlisted`** file is deployed and reachable by naming
it (`?build=<name>`, or the settings panel's Build selector) but is left out of
the `/builds/` listing. The marker is uploaded with the rest of the directory,
and the deploy reads it back — so where a catalogue is offered is decided in one
place, beside the images.

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

The site is **`reticulous.net`**. Two things put it there, and only one of them
lives in a repo at all:

```
reticulous.net.        A      185.199.108.153
reticulous.net.        A      185.199.109.153
reticulous.net.        A      185.199.110.153
reticulous.net.        A      185.199.111.153
reticulous.net.        AAAA   2606:50c0:8000::153
reticulous.net.        AAAA   2606:50c0:8001::153
reticulous.net.        AAAA   2606:50c0:8002::153
reticulous.net.        AAAA   2606:50c0:8003::153
www.reticulous.net.    CNAME  reticulous.github.io.
```

…and **Settings → Pages → Custom domain** on this repo, holding
`reticulous.net`, with **Enforce HTTPS** ticked once GitHub has issued the
certificate. All four A records are GitHub's published apex set and belong in
the zone together; the `www` record points at the org's `reticulous.github.io`,
not at the apex, and GitHub answers it with a redirect to whichever of the two
the Pages setting names.

There is deliberately **no `CNAME` file** here. That file is how a site
published *from a branch* names its domain. A site published by a workflow —
which this one is, for the reason in **The images** — carries its domain only in
the Pages setting: GitHub writes no `CNAME` file for such a deploy and ignores
one that turns up in the uploaded artifact. `url:` in `_config.yml` names the
domain as well, but only so Jekyll can build canonical links and the sitemap; it
decides nothing about what the site answers on.

The deploy carries everything `reticulous.net/flashmon/` serves, so the
cutover moves no path with it. `spangap.org/install.sh` is still on nginx and
still what `building.md` tells people to pipe into a shell; it has to survive
the day `spangap.org` moves.
