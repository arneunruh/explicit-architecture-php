FROM hgraca/explicit-architecture:app.sfn.base

ARG APP_ENV
ARG DATABASE_URL

ENV ENV='prd'

COPY ./build/container/prd/php.ini /usr/local/etc/php/php.ini

COPY ./assets       /opt/app/assets
COPY ./bin          /opt/app/bin
COPY ./config       /opt/app/config
COPY ./public       /opt/app/public
COPY ./src          /opt/app/src
COPY ./templates    /opt/app/templates
COPY ./translations /opt/app/translations

COPY ./composer.json        /opt/app
COPY ./composer.lock        /opt/app
COPY ./Makefile             /opt/app
COPY ./package.json         /opt/app
COPY ./symfony.lock         /opt/app
COPY ./webpack.config.js    /opt/app
COPY ./yarn.lock            /opt/app

WORKDIR /opt/app

RUN make dep-install-prd-guest && \
    mkdir -p /opt/app/var/data && \
    make db-setup-guest && \
    chmod -R 777 /opt/app/var && \
    make dep-clearcache-guest

# Heroku starts the app and assigns a random port to it. We need to make our app listen to that random port,
# so we can't just use the usual exec php command.
CMD ./bin/up.sh