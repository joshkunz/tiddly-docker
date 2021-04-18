# tiddly-docker

A basic Docker container for running the Node.js [variant](https://tiddlywiki.com/#Installing%20TiddlyWiki%20on%20Node.js:HelloThere%20GettingStarted%20%5B%5BInstalling%20TiddlyWiki%20on%20Node.js%5D%5D%20Community)
of [TiddlyWiki][], a personal Wiki.

Using it is straightforward, just run:

```bash
docker run ghcr.io/joshkunz/tiddly:latest
```

and a new wiki will be initialized and start listening on port 8080 in the
container. Options can be passed directly to TiddlyWiki using the normal
Docker syntax:

```bash
# --help is delivered to TiddlyWiki
docker run --rm -it ghcr.io/joshkunz/tiddly:latest --help
```

By default, the container looks for Wiki files in the `/wiki` directory. To
persist wiki files across instances, an external folder can be mounted to
that directory:

```bash
docker run -v /some/path:/wiki ghcr.io/joshkunz/tiddly:latest
```

The container can also be configured with the following variables:

| Variable | Description |
| -------- | ----------- |
| `WIKI_PATH` | Instead of `/wiki` this path will be used in the container. |
| `DISABLE_AUTO_INIT` | By default, the container will initialize the `WIKI_PATH` directory with a new empty wiki if there is no wiki manifest in the folder. If this environment is set to `true` (that exact text) it will disable this initialization behavior. |

[TiddlyWiki]: https://tiddlywiki.com
