---
allowed-tools: LS, Read
description: List all available slash commands
---

## Context
- Commands directory: !`ls -la ~/.claude/commands/`
- Aichaku commands: !`ls ~/.claude/commands/aichaku/ 2>/dev/null | sed 's/\.md$//' | sed 's/^/- \/aichaku:/' || echo "No aichaku commands found"`
- Security commands: !`ls ~/.claude/commands/security/ 2>/dev/null | sed 's/\.md$//' | sed 's/^/- \/security:/' || echo "No security commands found"`
- Development commands: !`ls ~/.claude/commands/dev/ 2>/dev/null | sed 's/\.md$//' | sed 's/^/- \/dev:/' || echo "No dev commands found"`
- Utility commands: !`ls ~/.claude/commands/utils/ 2>/dev/null | sed 's/\.md$//' | sed 's/^/- \/utils:/' || echo "No utils commands found"`

## Your task
Display all available slash commands organized by category based on the directory structure detected above.

Show the command categories found in the Context section above, and format them as a comprehensive command reference.

For each category that contains commands, display:
1. The category name and namespace
2. The list of available commands in that category
3. Brief usage notes

Also include the built-in Claude commands:

### Built-in Claude Commands
- `/add-dir` - Add working directories
- `/bug` - Report bugs  
- `/clear` - Clear conversation history
- `/config` - View/modify configuration
- `/help` - Get usage help
- `/init` - Initialize project
- `/login` - Switch Anthropic accounts
- `/review` - Request code review

### Usage Notes
- For namespaced commands, use: `/category:command` (e.g., `/aichaku:checkpoint`)
- For unique commands, you can use just: `/command`
- Commands are case-sensitive

Handle any arguments: $ARGUMENTS