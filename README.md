# Apache PHP web server for TBP framework

Use this image in your TBP Dockerfiles as base image with:

```FROM bitendian/tbp-web-server:latest```

## Timezone

By default, timezone is set to *Europe/Madrid*

### Change to custom timezone

Add this lines and modify ```TZ``` variable to your desired timezone.

```
# timezone
ENV TZ=Europe/Madrid

# for container
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# for PHP especifically
RUN printf '[PHP]\ndate.timezone = "%s"\n' "$TZ" > /usr/local/etc/php/conf.d/tzone.ini
```

## Locales

By default, container comes with *Catalan*, *Spanish* and *English* locales enabled.

### Add more locales

Add this lines and modify for your desired locales. Take care to run ```locale-gen``` at the end.

```
# Set usual locales
RUN sed -i 's/# ca_ES.UTF-8 UTF-8/ca_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

```
