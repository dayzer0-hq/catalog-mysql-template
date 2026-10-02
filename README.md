# MySQL schema starter

The starter repository for DayZer0's MySQL briefs. The deliverable on these
projects is **version-controlled SQL** — a schema, its constraints, an index, a
seed — not an application. This repo is the harness that runs that SQL; the SQL
itself is yours to write, and writing it is your first piece of work.

## What's here

- `run.sh` — a tiny migration runner. It connects to MySQL and applies the
  `.sql` files you write, in order. It carries **no schema** of its own.
- `.env.example` — the connection settings. Copy to `.env` and edit.
- `.gitignore`, `.github/PULL_REQUEST_TEMPLATE.md`.

## Requirements

- MySQL **8.0+** and its `mysql` command-line client
- `bash` (already on macOS and Linux)

## Run it

```bash
cp .env.example .env     # then edit .env for your local MySQL
./run.sh --check         # connect and print the server version
```

`--check` is the health check: if it prints a version and `OK`, your repo talks
to MySQL and you are ready to start ticket 1.

Once you have written SQL (for example `schema.sql`, then `seed.sql`):

```bash
./run.sh                 # applies every *.sql in this folder, sorted by name
./run.sh schema.sql      # or apply exactly the file(s) you name
```

Files are applied in lexical order, so name them so the order is right
(`schema.sql` before `seed.sql`).

## Workflow

One ticket, one branch, one pull request. Branch names carry the issue number
(`issue-1-core-tables`); put `Closes #N` in the pull request body so the merge
submits the ticket. Never commit straight to `main`.
