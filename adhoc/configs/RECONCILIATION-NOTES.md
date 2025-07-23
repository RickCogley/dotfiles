# Prettier/Markdownlint Reconciliation - 2025-07-23

## Problem Solved

**Infinite Loop Issue**: Prettier and markdownlint were conflicting over emphasis style:
- **Prettier** (opinionated): Always converts `*asterisk*` → `_underscore_` emphasis  
- **Markdownlint** (configurable): Was expecting `*asterisk*` emphasis style
- **Result**: Format → lint error → format → lint error (infinite loop)

## Solution Applied

**Accept Prettier's Underscore Preference**:
- Updated `.markdownlint-cli2.jsonc` line 146: `"MD049": { "style": "underscore" }`
- Both tools now work harmoniously together
- No more pre-commit hook failures due to emphasis conflicts

## Key Changes in `.markdownlint-cli2.jsonc`

```jsonc
// Before (conflicting):
"MD049": { "style": "asterisk" },

// After (reconciled):
"MD049": { "style": "underscore" }, // matches Prettier
```

## Why This Approach

1. **Prettier is intentionally opinionated** - no configuration for emphasis markers
2. **Fighting Prettier is counterproductive** - it will always win
3. **Underscore emphasis is valid Markdown** - both `_text_` and `*text*` work
4. **Consistency matters more than preference** - tools working together > individual choices

## Current Status

✅ **Pre-commit hooks pass**  
✅ **Formatting and linting are aligned**  
✅ **Professional standards maintained**  
✅ **No more infinite formatting loops**

## Files Updated

- `.markdownlint-cli2.jsonc` - Updated MD049 rule to underscore
- `.prettierrc` - No changes needed (works as intended)

These reconciled configurations are now the "source of truth" for future projects.

---

*Created: 2025-07-23*  
*Applied to: aichaku project and dotfiles*