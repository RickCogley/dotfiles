# Planning Mode

## 🏗️ PROJECT STRUCTURE - ALWAYS START HERE

When you hear any of these:

- "Let's add..." / "I want to..." / "Can we..."
- "Help me implement..." / "We need to..."
- "Fix..." / "Improve..." / "Change..."
- "Plan..." / "Shape..." / "Define..."

IMMEDIATELY create: 📁 `.claude/output/active-{YYYY-MM-DD}-{descriptive-name}/`
└── STATUS.md

This is automatic - users shouldn't need to ask!

**ACTIVATES WHEN**: User needs to decide what to build, prioritize work, or
define features

**TRIGGERS**: "plan", "shape", "prioritize", "what should we build", "define",
"scope"

## Quick Start

```
DETECT context → APPLY methodology rules → OUTPUT actionable plan
```

## Universal Planning Flow

1. **GATHER CONTEXT**
   ```
   ❓ Missing context? Ask:
   - Team or solo? 
   - Timeline?
   - Type of work?
   ```

2. **APPLY METHODOLOGY RULES**
   ```
   Shape Up → Create pitch (2 or 6 week appetite)
   Scrum → Build sprint backlog (velocity-limited)
   Kanban → Order queue (continuous flow)
   Lean → Define MVP (minimum to learn)
   ```

3. **OUTPUT STRUCTURED PLAN**
   ```
   SAVE TO: .claude/output/active-YYYY-MM-DD-[descriptive-name]/
   FORMAT: Methodology-specific template
   TRACK: Progress in STATUS.md
   ```

## Methodology Rules

### Shape Up Planning

```
INPUT: Problem or opportunity
PROCESS:
  1. Extract core problem
  2. Set appetite (2 or 6 weeks ONLY)
  3. Sketch solution (breadboard/fat marker)
  4. Identify rabbit holes
  5. Define no-gos
OUTPUT: pitch.md
```

### Scrum Planning

```
INPUT: Prioritized backlog + capacity
PROCESS:
  1. Calculate team capacity
  2. Select highest priority items
  3. Break into tasks
  4. Confirm sprint goal
OUTPUT: sprint-plan.md
```

### Kanban Planning

```
INPUT: Work requests
PROCESS:
  1. Classify work (urgent/standard/debt)
  2. Check queue levels
  3. Order by value/urgency
  4. Set WIP limits if needed
OUTPUT: Updated board state
```

### Lean Planning

```
INPUT: Hypothesis or problem
PROCESS:
  1. Define what to learn
  2. Identify minimum to build
  3. Set success metrics
  4. Plan experiment
OUTPUT: mvp-plan.md
```

## Context Adaptations

### Solo Mode

- Skip coordination steps
- Simplify templates
- Direct decisions

### Team Mode

- Add stakeholder check
- Include capacity planning
- Document decisions

### Urgent Mode

- Minimal planning
- Focus on immediate action
- Document later

## Quick Decision Templates

### "What should we build next?"

```
Based on: [detected context]
Options ranked by value:
1. [Highest value] - [effort] - [why]
2. [Next value] - [effort] - [why]
3. [Third option] - [effort] - [why]

Recommendation: [#1 because...]
Start with: [specific next action]
```

### "How should we scope this?"

```
Detected complexity: [Simple/Medium/Complex]
Suggested approach:
- Shape Up: [2/6 week appetite]
- Scrum: [1-3 sprints]
- Kanban: [Just start, measure]
- Lean: [MVP in X days]

Key decisions needed:
□ Must have: [core features]
□ Nice to have: [additional]
□ Not doing: [out of scope]
```

## Output Examples

### Minimal (Solo Kanban)

```
Task: Add user auth
Priority: High
Size: Medium
Start: When current task done
```

### Detailed (Team Shape Up)

```
# User Authentication Pitch

**Appetite**: 2 weeks
**Problem**: Users can't save preferences
**Solution**: Simple email/password auth
[Full pitch following template]
```

## Anti-Patterns to Avoid

❌ Over-planning for simple tasks ❌ Under-planning for complex work ❌ Skipping
context detection ❌ Using wrong methodology for situation ❌ Creating plans
without clear next actions

## Remember

Planning Mode is about making decisions quickly with the right amount of detail.
Always end with a clear next action.
