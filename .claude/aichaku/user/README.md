# Aichaku Project Customizations

This directory is yours to customize Aichaku's behavior. Files here are never modified during upgrades.

## Directory Structure

```
user/
├── prompts/      # Custom AI prompts
├── templates/    # Custom document templates  
└── methods/      # Custom methodology extensions
```

## How to Customize

### 1. Custom Prompts (prompts/)

Add files that extend or override default prompts:

**Example: prompts/standup-casual.md**
```markdown
When conducting daily standups, use a more casual tone.
Focus on blockers and collaboration opportunities.
Keep updates brief and action-oriented.
```

### 2. Custom Templates (templates/)

Add document templates for your organization:

**Example: templates/change-control.md**
```markdown
# Change Control Document

**Change ID**: CC-{date}-{number}
**Requestor**: 
**Date**: 
**Impact**: Low | Medium | High

## Change Description

## Business Justification

## Technical Details

## Rollback Plan

## Approvals
- [ ] Technical Lead
- [ ] Product Owner
- [ ] Operations
```

### 3. Custom Methods (methods/)

Extend methodologies with your practices:

**Example: methods/code-review-checklist.md**
```markdown
## Code Review Checklist

Before marking PR as ready:
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] Security considerations noted
- [ ] Performance impact assessed
- [ ] Breaking changes documented
```

## Methodology Blending

You can influence how Aichaku blends methodologies:

**Example: methods/blending-preferences.md**
```markdown
## Our Methodology Preferences

- Prefer Scrum terminology for ceremonies
- Use Shape Up for feature planning
- Apply XP practices for development
- Kanban for operational work
```

## Organization-Specific Terms

Define your organization's vocabulary:

**Example: methods/vocabulary.md**
```markdown
## Our Terms

- "Sprint" = 2-week iteration (not 3 weeks)
- "Epic" = Major feature (3-6 sprints)
- "Spike" = Research task (timeboxed)
- "Ship It Day" = Our hack day (monthly)
```

## Tips

1. **Start small** - Add customizations as needs arise
2. **Document why** - Help future team members understand
3. **Share patterns** - If something works well, document it
4. **Iterate** - Refine based on what helps your team

## Need Ideas?

- Look at your team's recurring questions
- Document decisions that keep coming up
- Capture templates you use repeatedly
- Note terminology that's unique to your org

Remember: These customizations make Aichaku work better for YOUR team.
