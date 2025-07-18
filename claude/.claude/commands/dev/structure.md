---
allowed-tools: Read
description: Show recommended project directory structure
---

# Recommended Project Directory Structure

Loading directory structure guidelines from global memory...

@~/.claude/CLAUDE.md

## Quick Reference

### Standard Project Structure

```
/
├── README.md              # Project overview
├── LICENSE                # License file
├── CHANGELOG.md           # Version history
├── package.json           # Build config (Node)
├── deno.json              # Build config (Deno)
├── tsconfig.json          # TypeScript config
│
├── /src                   # Source code
│   ├── index.ts           # Main entry point
│   ├── /components        # UI components
│   ├── /services          # Business logic
│   └── /utils             # Utilities
│
├── /tests                 # Test files
│   ├── /unit              # Unit tests
│   ├── /integration       # Integration tests
│   └── /e2e               # End-to-end tests
│
├── /docs                  # Documentation
│   ├── /api               # API docs
│   ├── /guides            # User guides
│   └── /projects          # Aichaku projects
│
├── /scripts               # Dev tools (NOT distributed)
│   ├── build.sh           # Build scripts
│   └── deploy.sh          # Deployment scripts
│
└── /examples              # Usage examples
```

### Key Principles

1. **Root Cleanliness**: Keep root minimal
2. **Clear Separation**: Runtime code vs dev tools
3. **Discoverability**: Standard names
4. **Distribution Awareness**: Know what gets packaged

### Language-Specific Examples

**TypeScript/Node.js:**
- `/src` - Source code
- `/dist` or `/build` - Compiled output
- `/node_modules` - Dependencies

**Python:**
- `/src/mypackage` - Package code
- `/tests` - Test files
- `/docs` - Sphinx docs

**Go:**
- `/cmd` - Command line apps
- `/pkg` - Library code
- `/internal` - Private code

$ARGUMENTS