#!/usr/bin/env bash
# run.sh — a tiny MySQL migration runner for DayZer0 catalog briefs.
#
# This is the starter harness, shared by every MySQL brief. It does NOT contain
# any brief's schema — writing the DDL is your first piece of work. The harness
# just connects to MySQL and applies the .sql files you write, in order.
#
# Usage:
#   ./run.sh --check         # connect and print the server version (health check)
#   ./run.sh                 # apply every *.sql in this folder, sorted by name
#   ./run.sh schema.sql ...  # apply exactly the files you name, in that order
#
# Connection comes from the environment (copy .env.example to .env and edit, or
# export these yourself). No credentials live in the repo.
set -euo pipefail

: "${DB_HOST:=127.0.0.1}"
: "${DB_PORT:=3306}"
: "${DB_USER:=root}"
: "${DB_PASS:=}"
: "${DB_NAME:=dayzero}"

[ -f .env ] && { set -a; . ./.env; set +a; }

mysql_do() {
  mysql --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" \
    ${DB_PASS:+--password="$DB_PASS"} "$@"
}

if ! command -v mysql >/dev/null 2>&1; then
  echo "error: the 'mysql' client is not on your PATH. Install MySQL 8.0+ first." >&2
  exit 1
fi

if [ "${1:-}" = "--check" ]; then
  echo "Connecting to $DB_USER@$DB_HOST:$DB_PORT ..."
  mysql_do -e "SELECT VERSION() AS mysql_version;"
  echo "OK — MySQL reachable."
  exit 0
fi

# Ensure the target database exists, then apply migrations into it.
mysql_do -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

if [ "$#" -gt 0 ]; then
  files=("$@")
else
  shopt -s nullglob
  files=(*.sql)
  shopt -u nullglob
fi

if [ "${#files[@]}" -eq 0 ]; then
  echo "No .sql files to apply yet. Write one (e.g. schema.sql), then re-run."
  echo "Connection works — try ./run.sh --check to confirm."
  exit 0
fi

for f in "${files[@]}"; do
  echo ">> applying $f"
  mysql_do "$DB_NAME" < "$f"
done
echo "OK — applied ${#files[@]} file(s) to $DB_NAME."
