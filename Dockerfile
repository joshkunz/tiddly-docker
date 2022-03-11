FROM node:17.7.1

# renovate: datasource=npm depName=tiddlywiki versioning=npm
ARG TIDDLYWIKI_VERSION=5.2.1

RUN npm install -g tiddlywiki@${TIDDLYWIKI_VERSION} && \
    tiddlywiki --version

ADD tiddlywiki_or_autoinit.sh /bin

ENV WIKI_PATH /wiki
ENV DISABLE_AUTO_INIT false

ENTRYPOINT ["tiddlywiki_or_autoinit.sh"]
CMD ["--listen", "host=0.0.0.0"]
