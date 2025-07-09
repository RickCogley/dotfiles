# Execution Plan: [Feature Name]

**PHASE**: BUILDING (AI Executor Mode)\
**EXECUTION**: Single-run implementation\
**TEMPLATE COMPLIANCE**: All tasks must be executable without human intervention

## Metadata

- **Source Pitch**: [Link to pitch]
- **Complexity**: Simple / Moderate / Complex
- **Estimated Tasks**: [Number]
- **AI Execution Mode**: Zero-shot
- **Created**: [Date]
- **Translator**: [Who translated this]

## Pre-Execution Checklist

- [ ] All dependencies available
- [ ] Code patterns identified
- [ ] File paths verified
- [ ] Tests approach defined
- [ ] No blockers identified

## Execution Order

### Phase 1: Setup & Dependencies

Tasks that prepare the codebase for the feature.

### Phase 2: Data Layer

Models, schemas, database tasks.

### Phase 3: Business Logic

Services, utilities, core functionality.

### Phase 4: UI Components

User interface and interactions.

### Phase 5: Integration

Wiring everything together.

### Phase 6: Testing

Unit and integration tests.

---

## Task Specifications

### Task #1: [Task Name]

**Type**: Create **File**: `src/models/Example.js` **Dependencies**: None

**Context**: [Why this task exists and what it enables]

**Current State**:

```javascript
// File doesn't exist yet
```

**Implementation Steps**:

1. Create the file at specified path
2. Add required imports
3. Define the model class
4. Export the module

**Code Pattern**:

```javascript
// Follow this pattern from src/models/User.js
import { Model } from "../lib/model";
import { validateRequired } from "../utils/validation";

export class Example extends Model {
  static schema = {
    field1: { type: String, required: true },
    field2: { type: Number, default: 0 },
  };

  constructor(data) {
    super(data);
    this.validate();
  }

  validate() {
    validateRequired(this, ["field1"]);
  }
}
```

**Success Criteria**:

- File exists at correct location
- Follows existing model pattern
- Exports correctly
- No syntax errors

**Test Approach**: Create `test/models/Example.test.js` with basic instantiation
and validation tests.

---

### Task #2: [Task Name]

**Type**: Modify **File**: `src/services/ExampleService.js` **Dependencies**:
[Task #1]

**Context**: [Why modifying this file]

**Current State**:

```javascript
// Starting at line 45
export class ExampleService {
  async getAll() {
    return this.db.query("SELECT * FROM examples");
  }
}
```

**Implementation Steps**:

1. Add import for new model
2. Add new method after getAll()
3. Implement business logic

**Code Changes**:

```javascript
// Add after line 2
import { Example } from '../models/Example';

// Add after getAll() method (line 48)
async create(data) {
  const example = new Example(data);
  const result = await this.db.insert('examples', example.toJSON());
  return new Example(result);
}
```

**Success Criteria**:

- Method added in correct location
- Uses the new model
- Handles errors appropriately
- Returns expected type

---

### Task #3: API Endpoint

[Continue pattern for all tasks...]

---

## Integration Points

### Component Integration Map

```
Model (Task #1) 
  ↓
Service (Task #2)
  ↓
API Route (Task #3)
  ↓
UI Component (Task #4)
```

### Shared Dependencies

- Database connection: `src/lib/db.js`
- Auth middleware: `src/middleware/auth.js`
- Validation utils: `src/utils/validation.js`

---

## Testing Strategy

### Unit Tests

- Each model: Basic instantiation, validation
- Each service: Mock DB, test business logic
- Each component: Render, user interactions

### Integration Tests

- API endpoints: Full request/response cycle
- UI flows: User can complete full feature

### Test File Locations

```
test/
  models/
    Example.test.js (Task #6)
  services/
    ExampleService.test.js (Task #7)
  api/
    example.test.js (Task #8)
  components/
    ExampleComponent.test.js (Task #9)
```

---

## Error Handling

### Expected Edge Cases

1. **Empty data**: Validate required fields
2. **Duplicate entries**: Return appropriate error
3. **Missing auth**: Return 401
4. **Invalid format**: Validate and sanitize

### Error Response Format

```javascript
{
  error: true,
  message: "Human readable message",
  code: "ERROR_CODE",
  details: {} // Optional
}
```

---

## Rollback Plan

If execution fails:

1. Identify which task failed
2. Revert any partial changes
3. Document the blocker
4. Create targeted fix plan

---

## Success Validation

After execution, verify:

- [ ] All tasks completed
- [ ] No syntax errors
- [ ] Tests pass
- [ ] Feature works end-to-end
- [ ] Code follows patterns
- [ ] No regressions

---

## Notes for AI Executor

- Start with Task #1 and proceed sequentially
- Each task builds on previous ones
- Don't skip tasks even if they seem simple
- If blocked, stop and report immediately
- Success means ALL tasks complete

---

## Phase Transition Checklist

**DURING BUILDING phase:**

- [ ] Execute tasks in specified order
- [ ] Report progress after each task
- [ ] Stop immediately if blocked
- [ ] No architecture changes or feature additions
- [ ] Focus only on implementation

**Moving to COOLDOWN phase requires:**

- [ ] All tasks completed successfully
- [ ] Tests passing
- [ ] Feature working end-to-end
- [ ] Execution report generated

**Claude Code Reminder**: Save execution reports to
`.claude/output/[status-YYYYMM-projectname]/execution-report.md`. Focus on
DOING, not discussing. Execute the plan exactly as written.
