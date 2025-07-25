---
allowed-tools: Write, Bash, Git
description: Save session summary to docs/checkpoints/checkpoint-YYYY-MM-DD-{descriptive-name}.md
---

## Context
- Current date: !`date +%Y-%m-%d`
- Current time: !`date +%H%M%S`
- Current directory: !`pwd`
- Git status: !`git status --porcelain | head -10`

## Your task
Create a session checkpoint documenting our work. Use the arguments "$ARGUMENTS" as the descriptive name.

**CRITICAL**: 
1. If $ARGUMENTS is empty, use "session-work" as the descriptive name
2. Follow this EXACT template structure. Do NOT add any additional fields, headers, or metadata. 
3. Do NOT add review dates, analyst names, or generation timestamps. This is a historical snapshot, not a living document.

Create the checkpoint file at `docs/checkpoints/checkpoint-{current-date}-{descriptive-name}.md` with this EXACT structure:

```markdown
# Session Checkpoint - {current-date} - {Descriptive Name}

## Summary of Work Accomplished

- [Specific task 1 with concrete outcome]
- [Specific task 2 with concrete outcome] 
- [Specific task 3 with concrete outcome]

## Key Technical Decisions

- **[Decision topic]**: [What was decided and why]
- **[Decision topic]**: [What was decided and why]

## Files Created/Modified

### Created
- `path/to/file.ext` - [Brief purpose]
- `path/to/file.ext` - [Brief purpose]

### Modified
- `path/to/file.ext` - [Type of change made]
- `path/to/file.ext` - [Type of change made]

## Problems Solved

- **[Problem]**: [Solution implemented]
- **[Problem]**: [Solution implemented]

## Lessons Learned

- [Specific insight or pattern discovered]
- [Specific insight or pattern discovered]

## Next Steps

- [Specific actionable item for future work]
- [Specific actionable item for future work]

---

*Checkpoint created: {timestamp}*
```

**REQUIREMENTS**:
1. Use ONLY the sections shown above
2. Replace {current-date} with actual date (YYYY-MM-DD format)
3. Replace {Descriptive Name} with the arguments provided
4. Replace {timestamp} with actual timestamp
5. Fill sections with actual content from the session
6. Use bullet points, not numbered lists
7. Be specific and factual, not aspirational
8. Do NOT add Executive Summary, Key Metrics, Strategic Position, or any analysis fields
9. Do NOT add Next Review, Generated, Analyst, or similar metadata

First create the docs/checkpoints directory if it doesn't exist, then create the checkpoint file with today's date and the descriptive name from the arguments.

Run a "preflight" check on the created file, making sure it is formatted and linted, then git add, git commit and git push only the created checkpoint file. 
