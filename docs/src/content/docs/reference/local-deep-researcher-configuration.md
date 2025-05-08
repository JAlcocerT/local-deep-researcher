---
title: 'Configuration Module'
description: 'Runtime settings for the research assistant'
# sidebar: reference
---

# configuration.py

Defines the `Configuration` model and `SearchAPI` enum used to parameterize the research pipeline.

```python
from enum import Enum
from pydantic import BaseModel, Field
from typing import Literal, Optional, Any

class SearchAPI(Enum):
    PERPLEXITY = "perplexity"
    TAVILY      = "tavily"
    DUCKDUCKGO  = "duckduckgo"
    SEARXNG     = "searxng"
```

## Class Configuration(BaseModel)

Fields:

- **max_web_research_loops**: `int` – how many search→summarize→reflect iterations to run (default 3).
- **local_llm**: `str` – model name (e.g. `"llama3.2"`).
- **llm_provider**: `Literal["ollama","lmstudio","openai","groq"]` (default `"ollama"`).
- **search_api**: `Literal[…]` (default `"duckduckgo"`).
- **fetch_full_page**: `bool` – include raw page HTML in results.
- **ollama_base_url**, **lmstudio_base_url**, **groq_api_base_url**: endpoints.
- **strip_thinking_tokens**: `bool` – remove `<think>…</think>` wrappers.
- **openai_model**, **openai_api_key**, **groq_model**, **groq_api_key**: provider credentials.

### from_runnable_config

```python
@classmethod
def from_runnable_config(cls, config: Optional[RunnableConfig] = None) -> Configuration:
    ...
```

Merge environment variables and a passed‐in `RunnableConfig["configurable"]` dict, then instantiate.
