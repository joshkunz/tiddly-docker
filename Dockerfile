FROM node:16.4.2

ARG TIDDLYWIKI_VERSION 5.1.23

RUN npm install -g tiddlywiki@${TIDDLYWIKI_VERSION} && \
    tiddlywiki --version

ADD tiddlywiki_or_autoinit.sh /bin

ENV WIKI_PATH /wiki
ENV DISABLE_AUTO_INIT false

ENTRYPOINT ["tiddlywiki_or_autoinit.sh"]
CMD ["--listen", "host=0.0.0.0"]
