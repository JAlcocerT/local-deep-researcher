---
title: 'Prompt Templates'
description: 'Re-usable instructions for LLM stages'
---

# prompts.py

Contains both helper and raw prompt texts used across the graph.

## get_current_date()

```python
def get_current_date() -> str:
    return datetime.now().strftime("%B %d, %Y")
```

## query_writer_instructions

Generates a JSON with keys:

```json
{
  "query": "...",
  "rationale": "..."
}
```

## summarizer_instructions

Guides the summary LLM to create or extend a coherent, focused summary.

## reflection_instructions

Produces a JSON:

```json
{
  "knowledge_gap": "...",
  "follow_up_query": "..."
}
```

These strings are `.format(...)`-ed with the topic, date, or existing summary.
