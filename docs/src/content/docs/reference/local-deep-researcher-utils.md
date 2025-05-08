---
title: 'Utilities & Search'
description: 'Helpers for formatting, deduplicating and running web searches'
---

# utils.py

## get_config_value(value: Any) → str

Convert `Enum` or `str` config values into a raw string.

## strip_thinking_tokens(text: str) → str

Remove all `<think>…</think>` blocks from model replies.

## deduplicate_and_format_sources(response, max_tokens_per_source, fetch_full_page=False) → str

- **Input**: dict or list of `{ "results": […] }`.
- **Output**: multi-section `Sources:` text, deduped by URL.
- Truncates `raw_content` if `fetch_full_page`.

## format_sources(search_results) → str

Bulleted list of `* title : url` from `search_results["results"]`.

## fetch_raw_content(url) → Optional[str]

Downloads HTML via `httpx` (10s timeout) and converts to Markdown.

---

### Search Wrappers

All are decorated with `@traceable` for LangSmith tracing.

- **duckduckgo_search(query, max_results=3, fetch_full_page=False)**  
  Uses `duckduckgo_search.DDGS`.

- **searxng_search(query, max_results=3, fetch_full_page=False)**  
  Uses `langchain_community.utilities.SearxSearchWrapper`.

- **tavily_search(query, fetch_full_page=True, max_results=3)**  
  Uses `TavilyClient` from `tavily`.

- **perplexity_search(query, perplexity_search_loop_count=0)**  
  Calls Perplexity’s API with `sonar-pro` model; returns one full citation + additional sources.

Each returns `{"results": List[Dict[str,Any]]}` suitable for further formatting.
