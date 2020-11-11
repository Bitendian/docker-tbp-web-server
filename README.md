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
