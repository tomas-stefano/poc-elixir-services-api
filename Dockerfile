FROM elixir:1.10-alpine as build

WORKDIR /app

RUN apk add --no-cache --update bash openssl vim

COPY lib ./lib
COPY config ./config
COPY mix.exs .
COPY mix.lock .
COPY priv ./priv

RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix deps.compile \
    && mix phx.digest \
    && mix release

CMD ["mix", "phx.server"]
