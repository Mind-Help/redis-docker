FROM debian as redisearch
WORKDIR /opt/plugins
RUN apt update && apt install -y git dash make cmake
COPY . .
RUN dash build_redisearch.sh

FROM rust:1.64.0-bullseye as redisjson
WORKDIR /opt/plugins
RUN apt update && apt install -y git dash make cmake clang
COPY . .
RUN dash build_redisjson.sh

FROM redis:latest
ARG PORT=6379
ARG PASSWORD=1234
RUN apt update && apt install -y gettext-base
COPY . .
COPY --from=redisearch /opt/plugins/redisearch.so ./
COPY --from=redisjson /opt/plugins/redisjson.so ./
EXPOSE ${PORT}
RUN envsubst < redis.conf.template >> redis.conf
ENTRYPOINT ["/usr/bin/redis-server", "./redis.conf"]