---
title: 'State Definitions'
description: 'Dataclasses for keeping the research state'
---

# state.py

Three `@dataclass` types define the inputs, evolving state, and final output:

```python
@dataclass(kw_only=True)
class SummaryState:
    research_topic:     str
    search_query:       str
    web_research_results: List[str] = field(default_factory=list)
    sources_gathered:   List[str]   = field(default_factory=list)
    research_loop_count: int         = 0
    running_summary:    str          = None

@dataclass(kw_only=True)
class SummaryStateInput:
    research_topic: str

@dataclass(kw_only=True)
class SummaryStateOutput:
    running_summary: str
```

- **SummaryState** holds every piece of data as the graph executes.
- **SummaryStateInput** seeds the initial topic.
- **SummaryStateOutput** exposes only the final summary.
