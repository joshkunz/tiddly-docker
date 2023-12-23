FROM node:21.5.0

# renovate: datasource=npm depName=tiddlywiki versioning=npm
ARG TIDDLYWIKI_VERSION=5.3.3

RUN npm install --location=global tiddlywiki@${TIDDLYWIKI_VERSION} && \
    tiddlywiki --version

ADD tiddlywiki_or_autoinit.sh /bin

ENV WIKI_PATH /wiki
ENV DISABLE_AUTO_INIT false

ENTRYPOINT ["tiddlywiki_or_autoinit.sh"]
CMD ["--listen", "host=0.0.0.0"]
