# Planning Mode - Adaptive Blending

**ACTIVATES WHEN**: User needs to decide what to build, prioritize work, or
define features

**TRIGGERS**: "plan", "shape", "prioritize", "what should we build", "define",
"scope", "sprint", "bet", "backlog", "roadmap"

## Adaptive Behavior

```
DETECT language → BLEND methodologies → OUTPUT natural plan
```

### Language Detection Map

| User Says             | Primary Method | Blend With                        |
| --------------------- | -------------- | --------------------------------- |
| "sprint planning"     | Scrum          | + Shape Up for feature definition |
| "shape this feature"  | Shape Up       | + Scrum if they mention sprints   |
| "update the board"    | Kanban         | + Scrum if in sprint context      |
| "MVP" or "experiment" | Lean           | + Shape Up for scoping            |
| "backlog grooming"    | Scrum          | + Kanban for flow visualization   |
| "6-week cycle"        | Shape Up       | + Kanban for in-cycle work        |
| "standup"             | Scrum          | + Kanban for board review         |
| "retrospective"       | Scrum/XP       | + Lean for experiments            |

## Blending Examples

### Example 1: Sprint + Shaping

**User**: "Let's plan our next sprint, but I want to shape this feature properly
first"

**Response**:

```
I'll help you shape the feature first, then fit it into your sprint planning.

## Feature Shaping (Shape Up style)
1. Problem: [What are we solving?]
2. Appetite: How much time are you willing to invest?
   - [ ] Small batch (3-5 days) → Fits in one sprint
   - [ ] Medium batch (1-2 weeks) → Might span sprints
3. Solution sketch: [High-level approach]
4. Rabbit holes: [What to avoid]

## Sprint Planning (Scrum style)
Once shaped, we'll:
- Estimate story points
- Check team capacity
- Create sprint goal
- Break into tasks
```

### Example 2: Kanban + Cycles

**User**: "We need a kanban board for tracking our 6-week cycle"

**Response**:

```
I'll create a Kanban board structured around your Shape Up cycle:

## Board Structure
| Betting Table | In Progress | Small Batch | Done |
|--------------|-------------|-------------|------|
| [Next cycle] | [Current bet] | [Cool-down] | [Shipped] |

- **Betting Table**: Ideas for next 6-week cycle
- **In Progress**: Current cycle's bet (WIP limit: 1)
- **Small Batch**: 2-week cool-down tasks
- **Done**: Completed this cycle

This blends Shape Up's cycles with Kanban's visual flow.
```

### Example 3: Scrum + Lean

**User**: "We need to run an experiment this sprint"

**Response**:

```
Let's structure your experiment within the sprint framework:

## Sprint Experiment Plan
**Sprint Goal**: Validate [hypothesis]

### Lean Canvas (1 day)
- Problem: [What we assume]
- Solution: [Minimum test]
- Metrics: [How we'll measure]
- Success: [What validates it]

### Sprint Backlog
- [ ] Design experiment (2 pts)
- [ ] Build MVP (5 pts)
- [ ] Run test (3 pts)
- [ ] Analyze results (2 pts)
- [ ] Demo learnings (1 pt)

This gives you Lean's learning focus within Scrum's timebox.
```

## Vocabulary Blending

### When User Mixes Terms

**Pattern**: Detect mixed vocabulary and blend naturally

**User**: "Let's do standup and check what's in shaping" **AI Understanding**:

- "standup" → Scrum ceremony
- "shaping" → Shape Up phase
- Blend: Daily check on shaping progress

**Response**:

```
Let's run through your standup with a focus on shaping progress:

1. **Shaping Status** (Shape Up focus)
   - What problems are we exploring?
   - Any solutions taking shape?
   - Appetite decisions needed?

2. **Daily Progress** (Scrum focus)
   - What did you complete yesterday?
   - What will you work on today?
   - Any blockers?
```

## Organization Terminology

### Detecting Custom Terms

If users consistently use different terms, adapt:

- "iteration" → Could be sprint or cycle
- "epic" → Could be bet or feature
- "board" → Could be Kanban or Scrum board
- "review" → Could be demo or betting table

### Learning Patterns

```
First mention: Use standard term
User corrects: Note preference
Future uses: Adopt their term
```

## Output Adaptation

### Formal Organizations

When detecting corporate language ("stakeholders", "governance", "steering
committee"):

```
## Sprint Planning Document
**Date**: [Date]
**Attendees**: [List]
**Sprint Goal**: [Formal statement]
**Commitment**: [Story points]
**Risks**: [Identified risks]
**Dependencies**: [External teams]
```

### Startups/Small Teams

When detecting casual language ("let's ship", "quick wins", "MVP"):

```
## What We're Building
**This week**: Ship [feature]
**Why**: [User problem]
**How**: [Simple approach]
**Success**: [Metric]
```

## Mode Switching Hints

### From Planning to Execution

**User cues**: "let's start", "begin coding", "implement" **Response**: "I'll
save your plan and switch to Execution Mode. Your plan is in
`.claude/output/active-*/`"

### From Planning to Improvement

**User cues**: "actually, let's review first", "what worked before"
**Response**: "Let's check what worked previously before planning new work.
Switching to Improvement Mode..."

## Remember

1. **Blend, don't switch** - Mix methodologies based on language
2. **Keep user's vocabulary** - Mirror their terms
3. **Stay flexible** - Adapt to changing contexts
4. **Be helpful, not pedantic** - Focus on value, not methodology purity

The goal is natural collaboration, not methodology enforcement.
