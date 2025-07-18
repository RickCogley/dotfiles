---
allowed-tools: Write, Bash
description: Save session summary to docs/checkpoints/checkpoint-YYYY-MM-DD-{descriptive-name}.md
---

## Context
- Current date: !`date +%Y-%m-%d`
- Current time: !`date +%H%M%S`
- Current directory: !`pwd`
- Git status: !`git status --porcelain | head -10`

## Your task
Create a session checkpoint documenting our work. Use the arguments "$ARGUMENTS" as the descriptive name.

Create the checkpoint file at `docs/checkpoints/checkpoint-{current-date}-{descriptive-name}.md` with the following structure:

```markdown
# Session Checkpoint - {current-date} - {Descriptive Name}

## Summary of Work Accomplished
[List main tasks completed with brief descriptions]

## Key Technical Decisions  
[Document important architectural/implementation choices and rationale]

## Files Created/Modified

### Created
- [List new files with purpose]

### Modified
- [List changed files with type of change]

## Problems Solved
[List issues resolved and their solutions]

## Lessons Learned
[Key insights or patterns discovered]

## Next Steps
[Potential future work or improvements]

---
*Checkpoint created: {timestamp}*
```

First create the docs/checkpoints directory if it doesn't exist, then create the checkpoint file with today's date and the descriptive name from the arguments.