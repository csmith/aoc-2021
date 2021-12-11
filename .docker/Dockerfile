FROM alpine 

ADD entrypoint.sh /entrypoint.sh
RUN apk add bash gawk; chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
VOLUME /code
