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
COPY --from=redisearch /opt/plugins/redisearch.so ./
COPY --from=redisjson /opt/plugins/redisjson.so ./
EXPOSE ${PORT}
ENTRYPOINT ["/usr/bin/redis-server", "--loadmodule", "./redisearch.so", "--loadmodule", "./redisjson.so", "--port", ${PORT}]