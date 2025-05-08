---
title: 'Local Deep Researcher'
description: 'High-level overview of the Local Deep Researcher project'
---

# Overview

**Local Deep Researcher** is a modular, iterative research assistant pipeline that combines local LLMs (via Ollama or LMStudio), OpenAI/Groq, and multiple web-search backends to:

1. Generate optimized search queries for a user-provided topic.
2. Execute web searches (DuckDuckGo, SearxNG, Perplexity, or Tavily).
3. Summarize and integrate findings into a running report.
4. Reflect on gaps and loop until a configurable depth is reached.
5. Produce a final well-cited summary.

## Key Features

- **Multi-provider LLM support** (Ollama, LMStudio, OpenAI, Groq).
- **Pluggable search APIs**: DuckDuckGo, SearxNG, Perplexity, Tavily.
- **Iterative summary & reflection** loop via a directed StateGraph.
- **Configurable depth**, model choice, and token-stripping options.
- **Structured JSON prompts** for consistent LLM output.

## Modules

- **configuration.py** – Define runtime settings (model names, API keys, loop depth).
- **graph.py** – Core LangGraph pipeline wiring nodes and transitions.
- **lmstudio.py** – LMStudio‐specific Chat wrapper (JSON output support).
- **prompts.py** – Reusable prompt templates & helper for current date.
- **state.py** – Dataclasses capturing the research state and I/O.
- **utils.py** – Helpers: dedupe & format sources, fetch HTML, run searches.

## Dependencies

- Python 3.10+
- pydantic, typing-extensions
- langchain-core, langchain-ollama, langchain-openai, langchain-groq
- langgraph
- tavily, duckduckgo-search, langchain-community (Searx wrapper)
- markdownify, httpx, requests
- langsmith (for @traceable)

## Configuration & Environment

Most options live in `Configuration` (see module docs). Common env vars:

- `OPENAI_API_KEY`, `GROQ_API_KEY`, `PERPLEXITY_API_KEY`
- `SEARXNG_URL` (defaults to `http://localhost:8888`)

To override, either pass a `RunnableConfig` or set environment variables matching field names (upper-cased).
