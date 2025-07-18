---
allowed-tools: Read
description: Show conventional commit format and InfoSec guidelines
---

# Conventional Commits & InfoSec Guidelines

Loading commit style guidelines from global memory...

@~/.claude/CLAUDE.md

## Quick Reference

### Conventional Commit Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Common Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes
- **refactor**: Code refactoring
- **test**: Test changes
- **chore**: Build/tool changes

### InfoSec Comments

Add InfoSec comments when changes have security implications:

**Format**: `InfoSec: [brief description of security impact]`

#### When to Include:
- Input validation or sanitization changes
- Authentication/authorization modifications
- Cryptographic operations or key handling
- Error handling affecting information disclosure
- Dependency updates (especially security patches)
- Rate limiting or DoS protection
- Security headers or CORS policy changes
- Logging changes affecting audit trails

#### Examples:
```
feat: add input validation to API endpoints

InfoSec: Prevents injection attacks and validates request size limits
```

```
fix: update authentication token handling

InfoSec: Improves credential security and reduces token exposure risk
```

```
chore: update dependencies to latest versions

InfoSec: Patches known security vulnerabilities in lodash and express
```

### CRITICAL: Never Add
- ❌ "Co-authored-by: Claude"
- ❌ "Generated with Claude Code"
- ❌ Any AI attribution

$ARGUMENTS