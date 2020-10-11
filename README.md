# MetadataApi

This is a Proof of concept in Elixir of
[MoJ Metadata API](https://ministryofjustice.github.io/form-builder-metadata-api-docs/)

## Caveats

I am new into Elixir so probably there are some improvements and refactors that
could be done.

## Setup

You need to have installed:

* Docker

Then:

```
  docker-compose up -d
  docker-compose exec metadata-app mix ecto.migrate
```

The application will run in the 0.0.0.0:4000
Have fun!
