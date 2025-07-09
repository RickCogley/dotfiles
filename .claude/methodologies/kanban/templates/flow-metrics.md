# Flow Metrics Report - [Period]

**Team**: [Team Name]\
**Period**: [Start Date] - [End Date]\
**Generated**: [Date]

## Executive Summary

| Key Metric      | This Period | Last Period | Change | Target   |
| --------------- | ----------- | ----------- | ------ | -------- |
| Throughput      | 24 items    | 20 items    | ↑ 20%  | 25 items |
| Avg Cycle Time  | 4.2 days    | 5.1 days    | ↓ 18%  | 4 days   |
| Avg Lead Time   | 12.3 days   | 14.7 days   | ↓ 16%  | 10 days  |
| Flow Efficiency | 34%         | 28%         | ↑ 6pp  | 40%      |

## Throughput Analysis

### Weekly Throughput

```
Week 1: ████████████ 12 items
Week 2: ██████████ 10 items  
Week 3: ████████████████ 16 items
Week 4: ██████████████ 14 items
```

### By Type

- Features: 45% (11 items)
- Bugs: 30% (7 items)
- Tech Debt: 15% (4 items)
- Support: 10% (2 items)

## Cycle Time Distribution

### Histogram

```
1 day:  ██ 2 items
2 days: ████████ 8 items
3 days: ██████ 6 items
4 days: ████ 4 items
5 days: ██ 2 items
6+ days: ██ 2 items
```

### Percentiles

- 50th percentile: 3 days
- 85th percentile: 5 days
- 95th percentile: 7 days

**SLA Performance**: 85% of items completed within 5-day SLA ✅

## Lead Time Analysis

### Components

```
Wait Time:      ████████░░░░ 67% (8.2 days)
Active Time:    ████░░░░░░░░ 33% (4.1 days)
Flow Efficiency: 33%
```

### By Priority

- Expedite: 1.2 days average
- High: 8.4 days average
- Normal: 14.2 days average
- Low: 21.3 days average

## WIP and Flow

### Average WIP by Column

```
Ready:       ████ 4.2
In Progress: ███ 3.1
Review:      ██ 1.8
Testing:     ██ 2.4
Total WIP:   11.5
```

### Little's Law Validation

```
Throughput = WIP / Cycle Time
5.7 items/week = 11.5 / 2.0 weeks ✓
```

## Blockers and Impediments

### Blocker Statistics

- Total blockers: 18
- Avg resolution time: 1.8 days
- Items blocked >1 time: 6 (25%)

### Blocker Categories

```
External Dependencies: ████████ 40%
Technical Issues:      ██████ 30%
Unclear Requirements:  ████ 20%
Resource Availability: ██ 10%
```

## Cumulative Flow Diagram Insights

### Observations

- WIP growing in Review stage (potential bottleneck)
- Smooth flow through Development
- Backlog growth rate sustainable

### Recommendations

1. Increase Review capacity or reduce WIP limit
2. Consider pairing for review activities
3. Automate more review checklist items

## Monte Carlo Forecast

### How many items in next 2 weeks?

```
Percentile | Items
-----------|-------
50%        | 10-12
85%        | 8-14
95%        | 6-16
```

### When will 20 items be complete?

```
Percentile | Days
-----------|------
50%        | 14
85%        | 18
95%        | 24
```

## Process Health Indicators

### Positive Trends ✅

- Cycle time decreasing consistently
- Blocker resolution time improving
- WIP limits mostly respected

### Areas of Concern ⚠️

- Flow efficiency below target
- Review stage becoming bottleneck
- Expedite lane used 3 times (target: 1)

## Action Items from Analysis

1. **Reduce Review WIP limit** from 3 to 2
   - Owner: Flow Manager
   - Experiment for 2 weeks

2. **Implement Review Pairing** for complex items
   - Owner: Team Lead
   - Define criteria by [date]

3. **Analyze Wait Time** in Ready column
   - Owner: Product Owner
   - Report by [date]

## Period Highlights

### Wins

- Delivered critical payment feature on time
- Reduced average cycle time by nearly 20%
- Zero critical bugs escaped to production

### Challenges

- Two expedite items (system outages)
- Review bottleneck emerged week 3
- Some items aged >10 days in backlog

## Next Period Focus

1. Achieve 40% flow efficiency
2. Maintain <4 day average cycle time
3. Reduce expedite usage to ≤1 per month
4. Implement approved experiments

---

**Next Review Date**: [Date]\
**Prepared by**: [Name]\
**Distribution**: Team, Stakeholders
