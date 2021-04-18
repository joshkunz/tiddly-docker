# vim: set syntax=bash:

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load 'test_helper/bats-file/load'

    if [[ -z "${CONTAINER}" ]]; then
        echo "CONTAINER must be set" >&2
        exit 1
    fi
}

spawn_background() {
    CONTAINER_ID="$(docker run \
        --rm --detach --label "test-tiddly-background=" "${CONTAINER}")"
    docker container inspect \
        --format '{{ .NetworkSettings.IPAddress }}' \
        "${CONTAINER_ID}"
}

# Retry a command a few times to see if it succeeds after a moment.
retry() {
    local tries
    tries=0
    until "$@"; do
        sleep 0.5
        if [[ "${tries}" -ge 5 ]]; then
            echo "failed 5 times"
            return 1
        fi
        tries=$(( tries + 1 ))
    done
}

teardown() {
    # Kill a background container if it exists.
    local id
    id="$(docker container ls -q --filter "label=test-tiddly-background")"
    if [[ -n "${id}" ]]; then
        docker kill "${id}" >/dev/null
    fi
}

@test "tiddlywiki starts" {
    docker run --rm -i "${CONTAINER}" --version
}

@test "tiddlywiki connectable" {
    local ip
    ip="$(spawn_background)"
    # By default, it should be serving on port 8080. Retry a few times
    # since it takes a bit for the server to come up. 
    retry nc -z "${ip}" 8080
}

@test "tiddlywiki sets up tiddly folders" {
    local dir
    dir="$(mktemp -d)"

    run docker run --rm -i -v "${dir}":/wiki "${CONTAINER}" --version
    assert_success

    # Make sure tiddlywiki automatically set up the file. 
    assert_file_exist "${dir}/tiddlywiki.info"
}

@test "don't set up tiddly folder when autoinit disabled" {
    local dir
    dir="$(mktemp -d)"

    run docker run --rm -i -v "${dir}":/wiki -e DISABLE_AUTO_INIT=true "${CONTAINER}" --version
    assert_success

    assert_file_not_exist "${dir}/tiddlywiki.info"
}

@test "wiki setup at alternate WIKI_PATH" {
    local dir
    dir="$(mktemp -d)"

    run docker run --rm -i \
        -v "${dir}":/alternate/wiki/path \
        -e WIKI_PATH=/alternate/wiki/path \
        "${CONTAINER}" --version
    assert_success

    assert_file_exist "${dir}/tiddlywiki.info"
}
