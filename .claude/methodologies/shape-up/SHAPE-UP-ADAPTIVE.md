# Shape Up - Adaptive Blending Guide

**BEST FOR**: Features with unclear solutions, fixed timeline projects, avoiding
scope creep

**TRIGGERS**: "shape", "appetite", "pitch", "betting table", "6 weeks", "cycle",
"bet", "cool-down"

## Blending With Other Methodologies

### Shape Up + Scrum

**When user mentions**: "sprint", "standup", "backlog", "story points"

```
## Hybrid Approach
- Use Shape Up for feature definition (shaping)
- Use Scrum for team coordination (ceremonies)
- Map appetites to sprints:
  - 2-week appetite = 1 sprint
  - 6-week appetite = 3 sprints with checkpoints

Example:
"Let's shape this for our next sprint" →
1. Shape the work (Shape Up)
2. Set appetite that fits sprint boundaries
3. Present at sprint planning (Scrum)
4. Run daily standups during build (Scrum)
```

### Shape Up + Kanban

**When user mentions**: "board", "flow", "WIP", "continuous"

```
## Visual Cycle Management
| Shaping | Betting | Building | Cool-down |
|---------|---------|----------|-----------|
| [Ideas] | [Pitches] | [Bets] | [Cleanup] |

- Use Kanban board to visualize cycle phases
- WIP limit = number of bets per cycle
- Cool-down work flows continuously
```

### Shape Up + Lean

**When user mentions**: "MVP", "experiment", "validate", "hypothesis"

```
## Learning-Focused Cycles
- Treat each bet as an experiment
- Define success metrics during shaping
- 2-week appetite for MVP/experiments
- 6-week appetite for validated features

Shaping becomes:
1. Hypothesis: [What we believe]
2. Experiment: [How we'll test]
3. Appetite: [Time to learn]
4. Success: [What validates it]
```

### Shape Up + XP

**When user mentions**: "TDD", "pairing", "refactoring", "continuous
integration"

```
## Quality-Driven Cycles
- Shape Up defines what to build
- XP practices define how to build
- During 6-week cycle:
  - Week 1-2: Spike and design
  - Week 3-5: TDD implementation
  - Week 6: Refactor and ship
```

## Vocabulary Mapping

| Shape Up Term | When User Says                        | Respond With                           |
| ------------- | ------------------------------------- | -------------------------------------- |
| Appetite      | "timeline", "deadline", "timeframe"   | "What's your appetite - 2 or 6 weeks?" |
| Bet           | "project", "initiative", "epic"       | "What are we betting on this cycle?"   |
| Pitch         | "proposal", "spec", "requirements"    | "Let's shape this into a pitch"        |
| Cycle         | "phase", "iteration", "period"        | "In this 6-week cycle..."              |
| Cool-down     | "cleanup", "tech debt", "maintenance" | "During cool-down we can..."           |

## Adaptive Templates

### When Blending is Detected

**User**: "We need to shape our backlog items for next sprint"

**Response Template**:

```markdown
## Shaped Backlog Items

### Item 1: [Feature Name]

**Problem**: [What users struggle with] **Appetite**: 1 sprint (2 weeks)
**Solution Sketch**: [Rough approach] **Story Points**: [If they use points]
**Acceptance Criteria**: [Scrum-style criteria]

### Item 2: [Feature Name]

[Same structure]

These shaped items are ready for sprint planning. Each has a clear problem,
solution approach, and fits within a sprint.
```

### Progressive Disclosure

Start simple, add methodology depth as needed:

**Level 1 - First Mention**: "For this feature, what's your appetite - 2 or 6
weeks?"

**Level 2 - Engagement**: "Let's shape this properly. What's the core problem?
What rabbit holes should we avoid?"

**Level 3 - Full Adoption**: "Ready for the betting table? Let's review all
pitches and decide what gets this cycle's capacity."

## Context Clues for Blending

### Organizational Maturity

- **Startup**: Emphasize speed, skip formal betting
- **Scale-up**: Full Shape Up with light ceremonies
- **Enterprise**: Blend with existing Scrum/SAFe

### Team Signals

- **"Our PM says..."**: More formal pitches needed
- **"Let's just build..."**: Emphasize shaping value
- **"In our retrospective..."**: Blend with Scrum patterns

### Project Types

- **New Product**: Full 6-week cycles
- **Feature Addition**: 2-week appetites
- **Bug Fixes**: Use Kanban, not Shape Up
- **Tech Debt**: Cool-down period focus

## Anti-Patterns to Recognize

### Shape Up Purist Warning Signs

❌ User frustrated by "no extensions" rule ✅ Adapt: "Let's scope to what fits
the time"

❌ Team wants more structure ✅ Blend: Add light Scrum ceremonies

❌ Stakeholders want detailed specs ✅ Enhance: Add acceptance criteria to
pitches

### Over-Blending Warnings

❌ Trying to estimate story points for shaped work ✅ Clarify: "Appetite
replaces estimation"

❌ Daily standups becoming status reports ✅ Refocus: "What's your biggest
unknown today?"

❌ Treating cool-down as a sprint ✅ Remind: "Cool-down is unstructured time"

## Remember

Shape Up's strength is solving problems with fixed time and variable scope. When
blending:

- Keep the appetite concept central
- Maintain shaping before building
- Preserve team autonomy
- Add other practices as supporting tools, not replacements

The goal is getting the benefits of Shape Up while fitting the user's context.
