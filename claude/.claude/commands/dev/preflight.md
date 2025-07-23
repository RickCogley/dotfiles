---
allowed-tools: Read, LS, Glob
description: Show preflight checks for current project  
---

## Context
- Current directory: !`pwd`
- Project config files: !`ls -la | grep -E "(deno\.json|package\.json|pyproject\.toml|Cargo\.toml|go\.mod)" || echo "No major config files found"`
- Available scripts: !`ls -la package.json deno.json 2>/dev/null | head -2`

## Your task
Detect the project type based on the configuration files found and show the appropriate preflight checks.

Based on the project configuration files detected above, provide the specific preflight commands for this project type:

**If deno.json exists** - Show Deno preflight checks:
```bash
deno fmt                    # Format TypeScript code
deno check **/*.ts         # Type check all TypeScript files  
deno lint                  # Run TypeScript linter
deno test                  # Run all tests
deno task markdown:format  # Format markdown files
deno task markdown:lint    # Lint markdown files
# Optional: deno task docs:lint  # Check documentation standards
```

**If package.json exists** - Show Node.js/npm preflight checks:
```bash
npm run format            # Format code (prettier, etc.)
npm run lint              # ESLint/TSLint
npm run type-check        # TypeScript compilation check
npm test                  # Run test suite
npm audit                 # Security vulnerability check
npx prettier --write "**/*.md"     # Format markdown files
npx markdownlint-cli2 "**/*.md"    # Lint markdown files
```

**If pyproject.toml exists** - Show Python preflight checks:
```bash
black .                   # Code formatting
mypy .                    # Type checking
flake8                    # Linting
pytest                    # Run tests
safety check              # Security vulnerability scanning
npx prettier --write "**/*.md"     # Format markdown files
npx markdownlint-cli2 "**/*.md"    # Lint markdown files
```

**If go.mod exists** - Show Go preflight checks:
```bash
go fmt ./...              # Format code
go vet ./...              # Static analysis
golint ./...              # Style linting
go test ./...             # Run tests
govulncheck ./...         # Security vulnerability check
npx prettier --write "**/*.md"     # Format markdown files
npx markdownlint-cli2 "**/*.md"    # Lint markdown files
```

**If Cargo.toml exists** - Show Rust preflight checks:
```bash
cargo fmt                 # Format code
cargo clippy              # Linting
cargo test                # Run tests
cargo audit               # Security vulnerability check
npx prettier --write "**/*.md"     # Format markdown files
npx markdownlint-cli2 "**/*.md"    # Lint markdown files
```

Show only the relevant checks for the detected project type. Always remind that these checks should be run before staging commits.

Handle any arguments: $ARGUMENTS