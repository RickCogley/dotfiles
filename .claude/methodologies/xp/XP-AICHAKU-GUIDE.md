# Extreme Programming (XP)

**BEST FOR**: Quality-critical code, learning teams, complex technical
challenges

**TRIGGERS**: "TDD", "test first", "pair programming", "refactor", "XP"

## Core Rules

### Planning Rules

- Small stories (1-3 days)
- Technical tasks included
- Customer sets priorities
- Team estimates

### Execution Rules

- Test first, always
- Pair when complex
- Refactor mercilessly
- Integrate continuously

### Improvement Rules

- Track test coverage
- Measure defect rates
- Monitor build times
- Increase pairing gradually

## Quick Templates

### TDD Cycle

```
1. RED: Write failing test
   test("user can login", () => {
     expect(login(user)).toBe(true);
   });

2. GREEN: Minimal code to pass
   function login(user) { return true; }

3. REFACTOR: Improve design
   function login(user) {
     return validateUser(user) && checkPassword(user);
   }
```

### Story Card

```
Story: [Feature name]
Estimate: [1-3 days]
Tasks:
□ Write acceptance test
□ TDD implementation
□ Refactor if needed
□ Integrate
```

### Pairing Schedule

```
Morning: Alice + Bob on Feature A
Afternoon: Alice + Carol on Bug B
Rule: Switch pairs daily
```

## Context Adaptations

**Solo**: Self-review protocols, rubber duck debugging **Remote**: Screen
sharing tools, collaborative IDEs **Learning**: Start with TDD, add practices
gradually

## Key Decisions

1. **When to Pair**
   - Complex algorithms
   - Critical features
   - Knowledge sharing
   - Bug hunting

2. **Refactoring Triggers**
   - Duplication found
   - Tests hard to write
   - Feature hard to add
   - Code smells detected

3. **Quality Standards**
   - 100% tests pass
   - Coverage > 80%
   - No known debt
   - Continuous green builds
