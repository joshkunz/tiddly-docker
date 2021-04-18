#!/bin/bash

die() {
    echo $@ >&2
    exit 1
}

[[ -n "${WIKI_PATH}" ]] || die "WIKI_PATH must be set"

if [[ ! -f "${WIKI_PATH}/tiddlywiki.info" && "${DISABLE_AUTO_INIT}" != "true" ]]; then
    tiddlywiki "${WIKI_PATH}" --init server || die "failed to init wiki"
fi

echo tiddlywiki "${WIKI_PATH}" "$@"
exec tiddlywiki "${WIKI_PATH}" "$@"
