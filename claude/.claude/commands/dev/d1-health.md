---
allowed-tools: Read, LS, Glob, Bash, mcp__cloudflare__search, mcp__cloudflare__execute
description: Run D1 database health audit — discovers databases from wrangler config or accepts explicit name
---

## Context
- Current directory: !`pwd`
- Wrangler config: !`ls wrangler.jsonc wrangler.json wrangler.toml 2>/dev/null || echo "No wrangler config found"`
- D1 bindings: !`cat wrangler.jsonc wrangler.json 2>/dev/null | grep -A2 '"database_name"' || echo "No D1 bindings found"`

## Arguments
$ARGUMENTS — Optional: a specific D1 database name. If empty, discover all from wrangler config.

## Tool strategy

**Prefer the Cloudflare MCP tools** (`mcp__cloudflare__search` and `mcp__cloudflare__execute`) over wrangler CLI when they are available. The MCP tools call the Cloudflare API directly — no wrangler install required, and they work even without a local wrangler config.

**Fall back to wrangler CLI** (`npx wrangler ...`) if:
- The MCP tools are not connected or fail with a connection error
- You need a command that has no API equivalent

### Using the Cloudflare MCP

1. **Find D1 endpoints**: Use `mcp__cloudflare__search` to locate D1 API endpoints (list databases, query, insights).
2. **Execute API calls**: Use `mcp__cloudflare__execute` to run JavaScript that calls the D1 API. The `execute` tool gives you a `cloudflare` object with a `request()` method for authenticated calls.

Example pattern for querying D1 via MCP:
```
// List databases
const dbs = await cloudflare.request('GET', '/accounts/{account_id}/d1/database');

// Query a database
const result = await cloudflare.request('POST', '/accounts/{account_id}/d1/database/{database_id}/query', {
  body: { sql: "PRAGMA quick_check" }
});
```

The MCP handles authentication automatically via OAuth.

## Your task

Run a comprehensive health audit on D1 databases for this project.

### Step 1: Discover databases

If `$ARGUMENTS` is provided and non-empty, use that as the single database name.

Otherwise, parse the wrangler config file found above and extract every `database_name` and `database_id` from the `d1_databases` array. If none found, report and stop.

### Step 2: For each database, run these checks

If using MCP: use the D1 API endpoints via `mcp__cloudflare__execute`. You'll need the `database_id` (from wrangler config or from listing databases via the API).

If using wrangler: use `npx wrangler d1 execute <db> --remote` for SQL commands.

If a check fails, note the error and continue to the next check.

#### 2a. Database info and size

**MCP**: `GET /accounts/{account_id}/d1/database/{database_id}` — returns size, row counts, metadata.

**Wrangler fallback**:
```bash
npx wrangler d1 info <db>
```

Flag if size exceeds 5GB (warning) or 8GB (critical) of the 10GB hard limit.

#### 2b. Integrity

**Query** (via MCP or wrangler):
```sql
PRAGMA quick_check
```

Report `ok` or any errors found.

#### 2c. Foreign key health

**Query** (via MCP or wrangler):
```sql
PRAGMA foreign_key_check
```

Report orphaned references if any.

#### 2d. Tables and row counts

**Query** (via MCP or wrangler):
```sql
SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name NOT LIKE 'sqlite_%' AND tbl_name NOT LIKE 'd1_%' AND tbl_name NOT LIKE '_cf_%' ORDER BY tbl_name
```

For each table, get row count. Flag tables over 100,000 rows as archiving candidates.

#### 2e. Index inventory

**Query** (via MCP or wrangler):
```sql
SELECT name, tbl_name FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%' ORDER BY tbl_name, name
```

Group by table. Flag tables with zero user-created indexes.

#### 2f. Query insights

**MCP**: Search for and use the D1 analytics/insights API endpoint if available.

**Wrangler fallback**:
```bash
npx wrangler d1 insights <db> --sort-type=sum --sort-by=time --limit=5
```

Flag queries with `avgRowsRead > 1000` or `avgDurationMs > 50` as needing index review. If command fails (experimental), note and continue.

### Step 3: Cross-reference codebase (best-effort)

Scan `src/` for Drizzle schema files (`schema.ts`, `schema/*.ts`, `db/schema.ts`). If found:

- List schema-defined tables and compare against actual database tables
- Look for `.where()` calls on columns that lack indexes
- Report findings as suggestions, not errors

### Step 4: Output report

```
## D1 Health Report — <database_name>
Date: <current date>
Method: Cloudflare MCP API | wrangler CLI

### Status
- Integrity: ✅ OK | ❌ Issues found
- Foreign keys: ✅ OK | ⚠️ Orphans found
- Size: <size> / 10GB (<percentage>%)

### Tables (<count>)
| Table | Rows | Indexes | Notes |
|-------|------|---------|-------|
| ...   | ...  | ...     | ...   |

### Index Coverage
- Tables with indexes: <count>
- Tables without custom indexes: <list>

### Slow Queries (from insights)
| Query (truncated) | Avg Duration | Avg Rows Read |
|-------------------|--------------|---------------|
| ...               | ...          | ...           |

### Recommendations
- <actionable items>
```

### Step 5: Offer follow-ups

Ask if the user wants to:
1. Run `PRAGMA optimize` on checked databases
2. Generate `CREATE INDEX` statements for flagged tables
3. Run `EXPLAIN QUERY PLAN` on slow queries from insights

**Never execute write operations without explicit user confirmation.**
