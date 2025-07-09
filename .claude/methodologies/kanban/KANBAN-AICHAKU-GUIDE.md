# Kanban

**BEST FOR**: Continuous flow work, support teams, varying priorities, starting
simply

**TRIGGERS**: "kanban", "flow", "WIP limit", "continuous", "pull"

## Core Rules

### Planning Rules

- Just-in-time decisions
- Pull when ready
- Limit work in progress
- Visualize everything

### Execution Rules

- Respect WIP limits absolutely
- Pull, don't push work
- Update board immediately
- Finish before starting

### Improvement Rules

- Measure cycle time
- Optimize bottlenecks
- Adjust WIP limits based on data
- Reduce waste continuously

## Quick Templates

### Board Setup

```
| Backlog | Ready(5) | Doing(3) | Review(2) | Done |
```

### Work Item

```
#123: [Title]
Type: [Feature/Bug/Debt]
Size: [S/M/L]
Age: [Days in column]
Blocked: [Yes/No]
```

### Flow Metrics

```
This week:
Items completed: [X]
Avg cycle time: [Y days]
WIP violations: [Z]
Bottleneck: [Column]
```

## Context Adaptations

**Solo**: Personal kanban (To Do → Doing → Done) **Team**: Full board with
handoff states **Mixed Work**: Separate swim lanes by type

## Key Decisions

1. **Setting WIP Limits**
   - Start: Team size × 1.5
   - Adjust: Based on flow data
   - Lower = Better flow

2. **Handling Urgency**
   - Expedite lane (max 1)
   - Clear criteria
   - Break WIP only if critical

3. **Board Evolution**
   - Start simple (3 columns)
   - Add states as needed
   - Split when bottlenecks appear
