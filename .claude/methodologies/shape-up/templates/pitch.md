# [Feature Name] Pitch

**PHASE**: SHAPING\
**NEXT PHASE**: BETTING (when pitch is complete)\
**TEMPLATE COMPLIANCE**: All 5 sections must be completed before moving to
betting

## 1. Problem

<!-- The raw idea, use case, or something we've seen that motivates us to work on this -->

**The Problem**: [Describe the specific problem]

**When it happens**: [Specific situation where users encounter this]

**Who it affects**: [Which users/personas experience this]

**Current workaround**: [What people do today without this feature]

**Why now**: [Why this is important to solve in this cycle]

### Evidence

<!-- Screenshots, quotes, or data showing the problem -->

[Include screenshots, support tickets, user quotes, or usage data]

---

## 2. Appetite

⏱️ **Small Batch** (2 weeks) / **Big Batch** (6 weeks)

<!-- How much time we want to spend on this, and why that's the right amount -->

This is a [Small/Big] Batch project because:

- [Reason 1 related to scope]
- [Reason 2 related to value]
- [Reason 3 related to constraints]

---

## 3. Solution

<!-- The core elements of the solution, presented as breadboards or fat marker sketches -->

### Approach

[High-level description of how we'll solve this problem]

### Elements

<!-- Use breadboarding for flow-focused solutions -->

#### Breadboard

```
Places:     [Screen A]    →    [Screen B]    →    [Screen C]
              ↓                   ↓                 ↓
Affordances: • Button X         • Field Y        • Action Z
             • Link W           • Option Q       • Submit

Flow:
1. User starts at [Screen A] and clicks [Button X]
2. This takes them to [Screen B] where they [action]
3. Finally, they reach [Screen C] and [complete goal]
```

<!-- Use fat marker sketches for layout-focused solutions -->

#### Fat Marker Sketch

```
┌─────────────────────────┐
│ ┌─────────────────────┐ │
│ │    Header Area      │ │
│ └─────────────────────┘ │
│                         │
│ ┌───────┐ ┌───────────┐ │
│ │ Nav   │ │           │ │
│ │ Menu  │ │  Main     │ │
│ │       │ │  Content  │ │
│ │       │ │  Area     │ │
│ └───────┘ └───────────┘ │
│                         │
│ [Primary Action Button] │
└─────────────────────────┘
```

### Key Flows

1. **[Flow name]**: User does X → System shows Y → User completes Z
2. **[Flow name]**: Starting from A → Navigate to B → Achieve outcome C

---

## 4. Rabbit Holes

<!-- Details about problems we aren't solving and things we need to be careful to avoid -->

### ⚠️ Technical Risks

- **[Risk 1]**: [What could go wrong] → [How we'll avoid it]
- **[Risk 2]**: [Complex part] → [Our simplification]

### ⚠️ Design Complexity

- **[Complexity 1]**: [What we're NOT trying to solve]
- **[Complexity 2]**: [Scope we're avoiding]

### ⚠️ Integration Concerns

- **[System 1]**: [What we assume works and won't touch]
- **[System 2]**: [External dependency we're working around]

---

## 5. No-gos

<!-- Functionality and use cases we specifically aren't covering -->

We are **NOT**:

- ❌ Building [feature/functionality that's out of scope]
- ❌ Supporting [use case we're explicitly excluding]
- ❌ Solving [related but separate problem]
- ❌ Integrating with [system/service we're avoiding]
- ❌ Handling [edge case we're accepting as limitation]

These are out of scope because:

- [Reason these would add too much complexity]
- [Reason these aren't essential to core problem]
- [Reason these can be addressed later if needed]

---

## Phase Transition Checklist

**Before moving to BETTING phase, verify:**

- [ ] Problem is clearly defined with evidence
- [ ] Appetite is set and justified
- [ ] Solution is sketched at the right level of detail
- [ ] All major rabbit holes are identified and patched
- [ ] No-gos explicitly state what we're NOT doing

**Claude Code Reminder**: This pitch should be saved to
`.claude/output/[status-YYYYMM-projectname]/pitch.md`. Only proceed to betting
when all sections are complete.
