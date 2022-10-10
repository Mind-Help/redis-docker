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

FROM redis-latest
ARG PORT=6379
COPY --from=redisearch /opt/plugins/redisearch.so ./
COPY --from=redisjson /opt/plugins/redisjson.so ./
RUN redis-server --loadmodule redisearch.so && redis-server --loadmodule redisjson.so
EXPOSE ${PORT}
CMD ["/usr/bin/redis-server", "--port", ${PORT}]