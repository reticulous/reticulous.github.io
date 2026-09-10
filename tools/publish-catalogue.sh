#!/bin/sh
# Publish a built image catalogue: upload builds/<catalogue>/ to its release,
# drop the assets the release no longer holds, and kick the Pages deploy that
# copies it onto the site.
#
#   spangap make-builds                       # in <workspace>/builds/<catalogue>
#   tools/publish-catalogue.sh stable ~/reticulous/builds/stable
#
# A catalogue is one release, tagged catalogue-<name>, whose assets are that
# directory verbatim — the image zips plus the index.html, timestamp and
# builds.yaml written beside them. The release is the durable store; the copy
# on the site is a deploy-time snapshot of it, because a browser cannot fetch a
# release asset cross-origin.
#
# Needs `gh`, authenticated as someone who can write to both repos.
set -eu

IMAGES_REPO="${IMAGES_REPO:-reticulous/reticulous}"
SITE_REPO="${SITE_REPO:-reticulous/reticulous.github.io}"

die() { echo "publish-catalogue: $*" >&2; exit 1; }

[ $# -eq 2 ] || die "usage: publish-catalogue.sh <catalogue> <path to builds/<catalogue>>"
cat_name=$1
dir=$2
tag="catalogue-${cat_name}"

[ -d "$dir" ] || die "$dir is not a directory"
[ -f "$dir/index.html" ] || die "$dir has no index.html — run \`spangap make-builds\` there first"
[ -f "$dir/timestamp" ] || die "$dir has no timestamp — run \`spangap make-builds\` there first"
command -v gh >/dev/null || die "gh is not installed"

# The catalogue directory, minus anything make-builds did not put there.
set -- "$dir/index.html" "$dir/timestamp"
[ -f "$dir/builds.yaml" ] && set -- "$@" "$dir/builds.yaml"
for z in "$dir"/*.zip; do
    [ -e "$z" ] || die "$dir holds no image zips"
    set -- "$@" "$z"
done

echo "==> ${tag} in ${IMAGES_REPO}: $# files, $(du -sh "$dir" | cut -f1)"

if ! gh release view "$tag" --repo "$IMAGES_REPO" >/dev/null 2>&1; then
    gh release create "$tag" \
        --repo "$IMAGES_REPO" \
        --title "Image catalogue: ${cat_name}" \
        --notes "Firmware images for the \`${cat_name}\` catalogue. The flasher at https://reticulous.github.io/flashmon/ serves a deploy-time copy of these; this release is the durable store." \
        --latest=false
fi

gh release upload "$tag" "$@" --repo "$IMAGES_REPO" --clobber

# Assets the rebuilt catalogue no longer contains: an image superseded by a
# newer stamp keeps its old name, so nothing overwrites it and it would linger
# in the release — and then on the site — forever.
keep=$(for f in "$@"; do basename "$f"; done)
gh release view "$tag" --repo "$IMAGES_REPO" --json assets --jq '.assets[].name' \
| while read -r have; do
    if ! printf '%s\n' "$keep" | grep -qxF "$have"; then
        echo "    - dropping superseded ${have}"
        gh release delete-asset "$tag" "$have" --repo "$IMAGES_REPO" --yes
    fi
done

echo "==> triggering the site deploy"
# No catalogue named in the payload on purpose: the deploy rebuilds the whole
# site, so it must publish every catalogue the site offers, not just this one.
gh api "repos/${SITE_REPO}/dispatches" \
    -f event_type=catalogue-published \
    >/dev/null

echo "==> done. Watch it with:  gh run watch --repo ${SITE_REPO}"
