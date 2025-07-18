---
allowed-tools: Read, Write, Edit, LS
description: Manage project-specific memory  
---

## Context

Arguments provided: $ARGUMENTS

Project memory context file: !`echo ~/.claude/project-context.md`
Current working directory: !`pwd`

## Your task

You are managing project-specific memory files. Parse the subcommand from the arguments and execute the appropriate action:

### If arguments contain "add":
1. Extract the file path from the arguments (everything after "add")
2. Validate the file path exists using the Read tool
3. Add the file path to ~/.claude/project-context.md (create if it doesn't exist)
4. Confirm the file was added to project context

### If arguments contain "remove":
1. Extract the file path from the arguments (everything after "remove")
2. Remove the file path from ~/.claude/project-context.md
3. Confirm the file was removed from project context

### If arguments contain "list":
1. Read ~/.claude/project-context.md if it exists
2. Display all files currently in the project context
3. If no context file exists, inform that no files are tracked

### Format for ~/.claude/project-context.md:
```
# Project Context Files

## Currently Tracked Files
- /path/to/file1.md
- /path/to/file2.md
- /path/to/file3.md

Last updated: [timestamp]
```

Execute the appropriate action based on the subcommand in the arguments.