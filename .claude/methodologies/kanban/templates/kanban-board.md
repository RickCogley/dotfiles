# Kanban Board - [Team/Project Name]

**Last Updated**: [Date Time]\
**Board Policy Version**: 1.0

## Board State

| **Backlog**       | **Ready (5)**       | **In Progress (3)**   | **Review (2)** | **Done**       |
| ----------------- | ------------------- | --------------------- | -------------- | -------------- |
| #45 Auth API      | #23 User Profile ⚡ | #12 Search Feature 🔴 | #34 API Docs   | #11 Login Flow |
| #67 Reports       | #29 Dashboard       | #19 Export CSV (3d)   | #38 Tests      | #22 Settings   |
| #72 Notifications | #31 Filters         | #21 Import (1d)       |                | #25 Header     |
| #78 Payments      | #44 Cache           |                       |                | #28 Footer     |
| #82 Analytics     |                     |                       |                | #30 Home Page  |
| #89 Admin Panel   |                     |                       |                |                |
| #91 Backup        |                     |                       |                |                |

**Legend**: ⚡ = Expedite, 🔴 = Blocked, (Xd) = Days in column

## WIP Limits

| Column      | Limit | Current | Status      |
| ----------- | ----- | ------- | ----------- |
| Ready       | 5     | 4       | ✅ Under    |
| In Progress | 3     | 3       | ⚠️ At Limit |
| Review      | 2     | 2       | ⚠️ At Limit |

## Blocked Items

| Item               | Blocked Since | Reason                      | Owner  |
| ------------------ | ------------- | --------------------------- | ------ |
| #12 Search Feature | 2 days ago    | Elasticsearch access needed | @alice |

## Aging Report

Items in progress > 5 days:

- None currently

Items in progress > 3 days:

- #12 Search Feature (3 days, blocked)

## Flow Metrics (Last 7 Days)

| Metric          | Value    | Trend  |
| --------------- | -------- | ------ |
| Throughput      | 8 items  | ↑ +2   |
| Avg Cycle Time  | 3.2 days | ↓ -0.5 |
| Avg Lead Time   | 8.7 days | → 0    |
| Flow Efficiency | 68%      | ↑ +5%  |

## Classes of Service

### Expedite Lane (Max 1)

**Current**: #23 User Profile **Criteria**: Production issues, security fixes
**SLA**: 24 hours

### Standard Work

**SLA**: 5 days (85th percentile) **Priority**: By product owner ranking

### Fixed Date Items

**Current**: None **Policy**: Start based on cycle time buffer

## Board Policies

### Ready to Pull

- [ ] User story clear
- [ ] Acceptance criteria defined
- [ ] No blockers identified
- [ ] Dependencies available
- [ ] Estimated (optional)

### Pull Policies

1. Respect WIP limits
2. Pull highest priority available
3. Finish before starting
4. Help blocked items first

### Done Criteria

- [ ] Code complete and merged
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Deployed to staging

## Team Agreements

- Daily standup at 9:30 AM (walk the board)
- Update board in real-time
- Flag blockers immediately
- Review metrics weekly
- Retrospective monthly

## Improvement Experiments

### Active Experiment

**Hypothesis**: Reducing Review WIP from 3 to 2 will reduce cycle time
**Started**: [Date] **Measure**: Avg cycle time for Review column **Target**:
20% reduction

### Experiment Backlog

1. Add automated testing column
2. Split development into frontend/backend
3. Implement pair programming for complex items

## Notes

[Any additional context, decisions, or observations about current board state]

---

**Next Review**: [Date] - Weekly flow review **Next Retrospective**: [Date] -
Monthly process improvement
