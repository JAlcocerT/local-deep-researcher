# Docker and Configuration Management

## Introduction to Docker in Local Deep Researcher

The Local Deep Researcher project includes Docker support, enabling containerized deployment for consistent execution across different environments. 

The Docker implementation simplifies dependency management and deployment while providing isolation from the host system.

```sh
#docker build -t local-deep-researcher-image:latest .
docker compose up -d
```

```sh
# Check if the services are running
docker-compose ps

# Pull the model specified in the environment (deepseek-r1:8b)
docker exec -it ollama ollama pull deepseek-r1:8b
docker exec -it local-deep-researcher sh

```

> https://smith.langchain.com/studio/thread?baseUrl=http://127.0.0.1:2024

## Use Cases for Docker

Docker serves several important functions in this project:

1. **Consistent Environment**: Ensures all dependencies and configurations are consistent across deployments
2. **Simplified Deployment**: Packages the application and its dependencies into a single container
3. **Isolation**: Separates the application from the host system
4. **Portability**: Enables running the application on any system with Docker support

## Docker Implementation

The Docker implementation is defined in the `Dockerfile` at the project root:

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PAGER=cat

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY pyproject.toml ./
COPY src/ ./src/
COPY README.md ./
COPY langgraph.json ./

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -e .

# Install langgraph CLI
RUN pip install "langgraph-cli[inmem]>=0.0.18"

# Set working directory for application
WORKDIR /app

# Run the langgraph server
CMD ["langgraph", "dev", "--host", "0.0.0.0"]
```

This Dockerfile:
1. Uses Python 3.11 as the base image
2. Sets up the working environment
3. Installs system dependencies
4. Copies project files
5. Installs Python dependencies
6. Configures the command to start the LangGraph server

## Configuration Management

The project implements a comprehensive configuration system that allows users to customize various aspects of the application. The configuration system is primarily implemented in `configuration.py` and follows a hierarchical approach.

### Configuration Design Pattern

The configuration system demonstrates several design patterns:

1. **Pydantic Model-Based Configuration**: Uses Pydantic for schema validation and type checking
2. **Priority-Based Configuration**: Values are loaded with a clear priority order:
   - Environment variables (highest priority)
   - LangGraph UI configuration
   - Default values (lowest priority)
3. **Enum-Based Constraints**: Uses Python enums for constrained configuration options

### Implementation Example

```python
# From src/ollama_deep_researcher/configuration.py
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
    # ... additional configuration fields ...

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
```

### Environment Variables

The project uses environment variables for configuration, with an `.env` file supported through `python-dotenv`. This approach allows:

1. **Local Development**: Developers can use a local `.env` file
2. **Production Deployment**: Environment variables can be set in the deployment environment
3. **Docker Configuration**: Environment variables can be passed to the Docker container

Example from `.env.example`:

```
# LLM Configuration
LLM_PROVIDER=openai          # Options: ollama, lmstudio, openai, groq
LOCAL_LLM=deepseek-r1:8b
OLLAMA_BASE_URL=http://192.168.1.11:11434

# Web Search Configuration
SEARCH_API='duckduckgo'
MAX_WEB_RESEARCH_LOOPS=3
FETCH_FULL_PAGE=True
```

## Integration with LangGraph Studio

The configuration system integrates with LangGraph Studio, allowing users to adjust settings through the UI:

1. Configuration values are exposed in the LangGraph Studio UI
2. Changes made in the UI take precedence over default values
3. Environment variables still take highest precedence

## Design Benefits

This approach to Docker and configuration provides several benefits:

1. **Flexibility**: Users can configure the application through multiple methods
2. **Transparency**: Configuration options are well-documented with descriptions
3. **Type Safety**: Pydantic ensures configuration values are properly typed
4. **Deployment Options**: Supports both local development and containerized deployment

## Technical Implementation Details

The Docker and configuration implementation follows these key principles:

1. **Separation of Concerns**: Configuration is separated from application logic
2. **Clear Defaults**: Every configuration option has a sensible default
3. **Validation**: Configuration values are validated at load time
4. **Documentation**: Each configuration option includes a description

This design allows the project to be easily deployed in various environments while providing users with the flexibility to customize the application to their specific needs.


---

```sh
pip install uv
uv export --format requirements-txt > requirements.txt
```