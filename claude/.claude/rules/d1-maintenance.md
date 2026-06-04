---
description: D1 database maintenance and optimization practices for Cloudflare D1
paths:
  - "**/wrangler.jsonc"
  - "**/wrangler.json"
  - "**/wrangler.toml"
  - "**/schema.ts"
  - "**/schema/*.ts"
  - "**/db/**"
  - "**/*.sql"
---

# D1 Database Maintenance Rules

When working with Cloudflare D1 databases, apply these practices automatically.

## Indexing

1. **Every hot-path query needs an index** — if a `WHERE`, `JOIN`, `ORDER BY`, or `GROUP BY` references a column, verify an index exists for it
2. **Use composite indexes** for columns filtered together — put the most selective column first: `CREATE INDEX idx_audit ON audit_log (client_id, created_at)`
3. **Use partial indexes** where applicable — `CREATE INDEX idx_active ON shares (token) WHERE revoked_at IS NULL`
4. **INTEGER PRIMARY KEY columns already have an implicit index** — don't create redundant ones
5. **Verify with EXPLAIN QUERY PLAN** — look for `SEARCH` (good) vs `SCAN` (needs index)

## After migrations or bulk data changes

1. Run `PRAGMA optimize` to refresh query planner statistics
2. Verify new or altered tables have appropriate indexes
3. Capture a Time Travel bookmark before the migration: `wrangler d1 time-travel info <db>`

## Periodic health checks

1. `PRAGMA quick_check` — validates database integrity (quarterly)
2. `PRAGMA foreign_key_check` — catches orphaned references (quarterly)
3. `wrangler d1 info <db>` — monitor size against the 10GB hard cap (monthly)
4. `wrangler d1 insights <db> --sort-by=time --limit=10` — find slow queries (monthly)

## Query patterns

1. **Use `db.batch()`** for multiple related queries — single network round-trip
2. **Always use prepared statements** with bound parameters
3. **Select only needed columns** — avoid `SELECT *` on tables with large text or JSON columns
4. **Use LIMIT on UPDATE and DELETE** — safety net against unbounded mutations

## Archiving

When databases grow large or contain stale data:

1. Export old records to R2 as JSON/CSV via scheduled Worker
2. Delete archived rows from D1
3. Run `PRAGMA optimize` after bulk deletes

## Red flags to call out

When reviewing D1 code or schemas, flag these issues:

- Missing indexes on columns used in WHERE clauses
- Full table scans on tables over 10,000 rows
- Sequential individual queries that should be batched
- `SELECT *` on wide tables in hot paths
- No Time Travel bookmark step in migration scripts
- Database size approaching 5GB without archiving strategy
