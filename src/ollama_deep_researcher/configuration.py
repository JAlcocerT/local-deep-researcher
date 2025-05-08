import os
from enum import Enum
from pydantic import BaseModel, Field
from typing import Any, Optional, Literal

from langchain_core.runnables import RunnableConfig

class SearchAPI(Enum):
    PERPLEXITY = "perplexity"
    TAVILY = "tavily"
    DUCKDUCKGO = "duckduckgo"
    SEARXNG = "searxng"

class Configuration(BaseModel):
    """The configurable fields for the research assistant."""

    max_web_research_loops: int = Field(
        default=3,
        title="Research Depth",
        description="Number of research iterations to perform"
    )
    local_llm: str = Field(
        default="llama3.2",
        title="LLM Model Name",
        description="Name of the LLM model to use"
    )
    llm_provider: Literal["ollama", "lmstudio", "openai", "groq"] = Field(
        default="ollama",
        title="LLM Provider",
        description="Provider for the LLM (Ollama, LMStudio, OpenAI, or Groq)"
    )
    search_api: Literal["perplexity", "tavily", "duckduckgo", "searxng"] = Field(
        default="duckduckgo",
        title="Search API",
        description="Web search API to use"
    )
    fetch_full_page: bool = Field(
        default=True,
        title="Fetch Full Page",
        description="Include the full page content in the search results"
    )
    ollama_base_url: str = Field(
        default="http://localhost:11434/",
        title="Ollama Base URL",
        description="Base URL for Ollama API"
    )
    lmstudio_base_url: str = Field(
        default="http://localhost:1234/v1",
        title="LMStudio Base URL",
        description="Base URL for LMStudio OpenAI-compatible API"
    )
    strip_thinking_tokens: bool = Field(
        default=True,
        title="Strip Thinking Tokens",
        description="Whether to strip <think> tokens from model responses"
    )
    openai_model: str = Field(
        default="gpt-3.5-turbo",
        title="OpenAI Model Name",
        description="Name of the OpenAI model to use when LLM Provider is 'openai'"
    )
    openai_api_key: Optional[str] = Field(
        default=None,
        title="OpenAI API Key",
        description="API key for OpenAI; will fallback to OPENAI_API_KEY env var if not provided"
    )
    groq_model: str = Field(
        default="groq-bison",
        title="Groq Model Name",
        description="Name of the Groq model to use when LLM Provider is 'groq'"
    )
    groq_api_key: Optional[str] = Field(
        default=None,
        title="Groq API Key",
        description="API key for Groq; will fallback to GROQ_API_KEY env var if not provided"
    )
    groq_api_base_url: str = Field(
        default="https://api.groq.ai/v1",
        title="Groq API Base URL",
        description="Base URL for Groq API (OpenAI-compatible endpoint)"
    )

    @classmethod
    def from_runnable_config(
        cls, config: Optional[RunnableConfig] = None
    ) -> "Configuration":
        """Create a Configuration instance from a RunnableConfig."""
        configurable = (
            config["configurable"] if config and "configurable" in config else {}
        )
        
        # Get raw values from environment or config
        raw_values: dict[str, Any] = {
            name: os.environ.get(name.upper(), configurable.get(name))
            for name in cls.model_fields.keys()
        }
        
        # Filter out None values
        values = {k: v for k, v in raw_values.items() if v is not None}
        
        return cls(**values)