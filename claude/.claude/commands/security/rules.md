---
allowed-tools: Read
description: Show DevSkim and CodeQL suppression syntax
---

# Security Scanning Suppression Syntax

I'll show you the correct suppression syntax for DevSkim and CodeQL from the global memory.

@~/.claude/CLAUDE.md

## Quick Reference

### DevSkim Suppressions
- **Format**: `// DevSkim: ignore DS######`
- **Placement**: MUST be at the END of the offending line
- **Example**: `const testSha = "abc123"; // DevSkim: ignore DS162092`

### CodeQL Suppressions  
- **Format**: `// codeql[rule-id]`
- **Placement**: MUST be on a SEPARATE LINE BEFORE the code
- **Example**:
  ```javascript
  // codeql[js/regex/missing-regexp-anchor]
  const pattern = /shields\.io\/badge/g;
  ```

### Key Difference
- ❌ DevSkim on separate line (wrong)
- ❌ CodeQL inline at end (wrong)
- ✅ DevSkim = inline at end
- ✅ CodeQL = separate line before

$ARGUMENTS