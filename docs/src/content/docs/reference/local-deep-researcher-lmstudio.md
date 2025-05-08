---
title: 'LMStudio Integration'
description: 'ChatLMStudio wrapper for OpenAI-compatible API'
---

# lmstudio.py

Extends `langchain_openai.ChatOpenAI` to support LMStudio’s local inference server and optional JSON formatting.

```python
class ChatLMStudio(ChatOpenAI):
    format: Optional[str]  # e.g. "json"

    def __init__(self, base_url, model, temperature=0.7, format=None, api_key="…", **kwargs):
        super().__init__(base_url=base_url, model=model, temperature=temperature, api_key=api_key, **kwargs)
        self.format = format

    def _generate(self, messages, stop=None, run_manager=None, **kwargs) -> ChatResult:
        if self.format == "json":
            kwargs["response_format"] = {"type": "json_object"}
        result = super()._generate(messages, stop, run_manager, **kwargs)
        if self.format == "json":
            # Attempt to extract & validate JSON substring
            …
        return result
```

**Usage Example**

```python
lm = ChatLMStudio(
    base_url="http://localhost:1234/v1",
    model="qwen_qwq-32b",
    temperature=0,
    format="json",
)
response = lm.invoke([SystemMessage("…"), HumanMessage("…")])
```
