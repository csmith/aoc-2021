FROM alpine 

ADD entrypoint.sh /entrypoint.sh
RUN apk add gawk; chmod +x /entrypoint.sh

CMD /entrypoint.sh
VOLUME /code
