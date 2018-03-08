#!/bin/sh

db_migrate=true

while true; do
  case "$1" in
    --no-migrate)
      db_migrate=false
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
  shift
done

if $db_migrate; then
  bundle exec rails db:migrate
fi

exec "$@"
