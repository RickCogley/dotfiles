# Aichaku Methodology Blending Guide

## 🏗️ PROJECT STRUCTURE - ALWAYS START HERE

For ANY new work, feature, or change, IMMEDIATELY create: 📁
`.claude/output/active-{YYYY-MM-DD}-{descriptive-name}/` └── STATUS.md

This happens AUTOMATICALLY when users say:

- "Let's..." / "I want to..." / "Can we..."
- "Help me..." / "We need to..." / "Fix..."
- "Add..." / "Improve..." / "Change..."

Users should NEVER need to ask for this structure!

## Core Principle

**Adapt to the user's language, don't force them to adapt to yours.**

When users mix terminology from different methodologies, blend approaches
naturally rather than correcting them. This guide helps AI assistants understand
how to combine methodologies based on context.

## Quick Reference Matrix

| User Language            | Primary Method | Natural Blends             |
| ------------------------ | -------------- | -------------------------- |
| "sprint" + "shaping"     | Scrum base     | + Shape Up for definition  |
| "kanban" + "cycle"       | Shape Up base  | + Kanban for visualization |
| "standup" + "betting"    | Shape Up base  | + Scrum ceremonies         |
| "MVP" + "sprint"         | Scrum base     | + Lean experiments         |
| "flow" + "retrospective" | Kanban base    | + Scrum improvement        |
| "pairing" + "appetite"   | Shape Up base  | + XP practices             |

## Blending Patterns

### 1. Ceremony Blending

Users often want familiar ceremonies with new methods:

```
User: "Let's do our daily standup and check the bets"
AI: Combines Scrum ceremony with Shape Up concepts
- Run standup format (Scrum)
- Focus on bet progress (Shape Up)
- Keep it brief (both)
```

### 2. Planning Blending

Different planning approaches can complement each other:

```
User: "We need to shape our backlog"
AI: Merges Shape Up shaping with Scrum backlog
- Shape problems into pitches (Shape Up)
- Organize as backlog items (Scrum)
- Prioritize by value (both)
```

### 3. Tracking Blending

Visual management crosses all methodologies:

```
User: "Show our sprint progress on the kanban board"
AI: Creates hybrid visualization
- Sprint swimlane (Scrum)
- Flow columns (Kanban)
- WIP limits (Kanban)
- Sprint boundary (Scrum)
```

## Language Detection

### Methodology Indicators

**Shape Up Signals**:

- appetite, pitch, bet, cycle, shaping, rabbit hole, cool-down

**Scrum Signals**:

- sprint, backlog, story points, velocity, standup, retrospective

**Kanban Signals**:

- board, flow, WIP, pull, continuous, queue, throughput

**Lean Signals**:

- MVP, hypothesis, validate, experiment, pivot, measure

**XP Signals**:

- TDD, pairing, refactoring, continuous integration, simple design

### Context Modifiers

**Formal Context** (enterprise, compliance, governance):

- Add more documentation
- Include stakeholder sections
- Formal templates

**Startup Context** (move fast, ship, iterate):

- Simplify processes
- Focus on core value
- Minimal documentation

**Team Size Context**:

- Solo: Skip coordination overhead
- Small (2-5): Light process
- Medium (6-15): Full ceremonies
- Large (15+): Add structure

## Blending Examples

### Example 1: Scrum Team Wanting Better Definition

**Situation**: Scrum team struggling with unclear requirements

**Blend**: Shape Up shaping + Scrum planning

```
1. Pre-Sprint Shaping Session
   - Shape problems into clear pitches
   - Set appetite (maps to sprint capacity)
   - Identify rabbit holes

2. Sprint Planning
   - Present shaped work
   - Team estimates complexity
   - Commit to sprint goal
```

### Example 2: Shape Up Team Needing More Visibility

**Situation**: Stakeholders can't see progress during 6-week cycle

**Blend**: Shape Up cycles + Kanban visualization

```
Cycle Kanban Board:
| Shaping | Ready to Bet | Week 1-2 | Week 3-4 | Week 5-6 | Shipped |

- Maintain Shape Up autonomy
- Add visual progress
- No daily standups unless team wants
```

### Example 3: Kanban Team Wanting Improvement Rhythm

**Situation**: Continuous flow lacks reflection time

**Blend**: Kanban flow + Scrum retrospectives

```
- Continue Kanban flow
- Add bi-weekly retrospectives
- Focus on flow metrics
- Identify improvement experiments
```

## Common Patterns

### The "Enterprise Agile" Pattern

Large organizations often have existing process:

```
User vocabulary: "SAFe", "PI planning", "epics"
Aichaku approach:
- Map cycles to PIs
- Treat epics as shaped work
- Maintain existing ceremonies
- Add Aichaku practices gradually
```

### The "Startup Pivot" Pattern

Fast-moving teams needing structure:

```
User vocabulary: "ship it", "MVP", "iterate"
Aichaku approach:
- Ultra-light Shape Up (2-week appetites)
- Kanban for daily work
- Lean for experiments
- Skip heavy process
```

### The "Quality Focus" Pattern

Teams emphasizing technical excellence:

```
User vocabulary: "technical debt", "refactoring", "testing"
Aichaku approach:
- XP practices as base
- Shape Up for feature work
- Kanban for debt/bugs
- Regular improvement cycles
```

## Adaptive Responses

### Level 1: Acknowledge

Recognize their terminology: "I see you're using sprints. Let me help you shape
this feature for your next sprint."

### Level 2: Blend

Combine naturally: "Let's create a sprint plan that includes your shaped bets
and handles the support work flow."

### Level 3: Enhance

Add value through combination: "Your sprint + kanban approach is great. We can
add shaping to reduce mid-sprint surprises."

## What NOT to Do

❌ **Don't Correct Terminology** User: "Our sprint betting session" Wrong:
"Actually, it's either sprint planning OR betting table" Right: "Let's run your
sprint betting session..."

❌ **Don't Force Purity** User: "We do Scrum but like Shape Up's no-estimates"
Wrong: "You can't mix these methodologies" Right: "Great! Use sprints for
rhythm, appetites for sizing"

❌ **Don't Overwhelm** User: "What's the best way to plan?" Wrong: [Long
explanation of all methodologies] Right: "What kind of work are you planning?"

## Remember

1. **User's language is the guide** - Mirror their terms
2. **Blend gradually** - Don't change everything at once
3. **Value over methodology** - Focus on what helps
4. **Context is king** - Adapt to their situation
5. **Natural combinations** - Some methods blend better

The goal is to be helpful, not methodologically pure. Aichaku adapts to users,
not the other way around.
