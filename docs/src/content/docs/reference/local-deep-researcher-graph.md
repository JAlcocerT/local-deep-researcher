---
title: 'Graph Pipeline'
description: 'Flow of research nodes and routing logic'
---

# graph.py

Defines a LangGraph `StateGraph` that orchestrates research steps using `SummaryState`.

## Nodes

1. **generate_query(state, config) → { "search_query": str }**  
   Uses an LLM to turn `state.research_topic` into a JSON `{"query":…,"rationale":…}` and extracts the `query`.

2. **web_research(state, config) → { "sources_gathered": [str], "research_loop_count": int, "web_research_results": [str] }**  
   Dispatches to one of:
   - `tavily_search`
   - `perplexity_search`
   - `duckduckgo_search`
   - `searxng_search`  
   Deduplicates and formats sources.

3. **summarize_sources(state, config) → { "running_summary": str }**  
   Summarizes new results, merging with any existing summary.

4. **reflect_on_summary(state, config) → { "search_query": str }**  
   Analyzes current summary for gaps and emits a follow-up query JSON.

5. **finalize_summary(state) → { "running_summary": str }**  
   Deduplicates all gathered sources, appends them to the summary under “Sources”.

6. **route_research(state, config) → Literal["web_research","finalize_summary"]**  
   Chooses to loop or end based on `state.research_loop_count` vs. `max_web_research_loops`.

## Graph Definition

```python
builder = StateGraph(
    SummaryState,
    input=SummaryStateInput,
    output=SummaryStateOutput,
    config_schema=Configuration
)
builder.add_node("generate_query",        generate_query)
builder.add_node("web_research",          web_research)
builder.add_node("summarize_sources",     summarize_sources)
builder.add_node("reflect_on_summary",    reflect_on_summary)
builder.add_node("finalize_summary",      finalize_summary)
builder.add_conditional_edges("reflect_on_summary", route_research)
# … edges from START to END …
graph = builder.compile()
```
