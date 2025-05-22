# Local Deep Researcher - Onboarding Documentation

> Generated with Windsurf

```txt
You are an AI documentation generator.

Your task is to create **user on boarding documentation for the SpeedUp cloned project** and write a post as markdown file where specified.

The idea is to collect all high level project information to make new developers more knowledgable after they read this guide.

Every section, will be used later on for further analysis and additional posts creations (on a separated prompt, to gain knowledge depth)

**1. Project Files: Input**

* Inspect the content of the files located in the `./sdlc-speedup` directory 
* You can ignore the `./sdlc-speedup/documentaition/` folder
* Process the content of the important files to understand the project's structure, modules, functions, classes, and overall functionality.

**2. Items to do:**

Collect the project information, by following the steps below.

* First of all, note the programming languages and tools, that are used in the project.
* Stack Overview — versions of languages, main frameworks
* Is it a monorepo? If it is, list all the features that make you thi 
nk so.
* Then, create the installation instructions for:
  * User of code, who will only use it as high-level project.
  * Inspect the command-line arguments, or endpoints, or other information, how do user will communicate with this project.
* Define contributing rules if you can find them along any of the readme files.
* Define from which files have you infered this information: You can add this as a Sources & Inference section of the post as H3.

Then, using this information as the most important, that should be a first place information available to user, follow the *Documentation Requirements*,
described in next section.

**3. Documentation Requirements:**

The generated documentation should aim to cover the following aspects (please be as comprehensive as possible based on the code):

* **Project Overview:** A high-level summary of the project's purpose and main features.
* **Key Concepts and Algorithms:** If the code implements any significant algorithms or concepts, explain them in a clear and understandable way.
* **Dependencies:** List any external libraries or dependencies used by the project.
* Create one `index.md` with the high level overview: description of the project, key features, modules, dependencies, configuration and environment, also Static code analysis (languages, structure, dependencies).

For each of the main project technologies. Create independent posts to provide additional information about it, including: include further framework context and why and where is it used in this project:
* List the uses cases for the code base
* Referencing to sample code and file that is using it
* What it is the technology use case (design patterns)
```

## Project Overview

Local Deep Researcher is a fully local web research assistant that uses Large Language Models (LLMs) hosted by [Ollama](https://ollama.com/search) or [LMStudio](https://lmstudio.ai/). 

The project enables users to conduct deep research on any topic by leveraging local LLMs combined with web search capabilities.

The application works by taking a user-provided topic, generating web search queries, gathering search results, summarizing findings, identifying knowledge gaps, and iteratively improving the research through multiple cycles.

The final output is a comprehensive markdown summary with citations to all sources used during the research process.

## Key Features

- **Fully Local Operation**: Can run entirely on your local machine without requiring external API services for LLM inference
- **Iterative Research Process**: Implements an IterDRAG-inspired approach with multiple research cycles

- **Multiple LLM Provider Support**: Works with Ollama, LMStudio, OpenAI, and Groq!

- **Flexible Search Options**: Supports multiple search engines including DuckDuckGo, Tavily, Perplexity, and SearXNG

- **Visual Process Monitoring**: Integration with LangGraph Studio for visualizing the research workflow
- **Configurable Research Parameters**: Customizable search depth, model selection, and other parameters
- **Source Citation**: Automatically includes citations to all sources used in the research
- **Docker Support**: Can be deployed as a Docker container

## Stack Overview

### Programming Languages

- **Python**: 3.9+ (3.11 recommended)

### Main Frameworks and Tools

- **[LangGraph](https://github.com/langchain-ai/langgraph)**: Core framework for building the research workflow (v0.2.55+)
- **[LangChain](https://github.com/langchain-ai/langchain)**: Used for LLM interactions and integrations
- **[Ollama](https://ollama.com/)**: Local LLM hosting and inference
- **[LMStudio](https://lmstudio.ai/)**: Alternative for local LLM hosting
- **[DuckDuckGo Search](https://github.com/deedy5/duckduckgo_search)**: Default web search provider
- **UV Package Manager**: Recommended for dependency management

### Project Structure

The project follows a straightforward structure:
- `src/ollama_deep_researcher/`: Core Python package
  - `configuration.py`: Configuration settings and environment variables
  - `graph.py`: Main LangGraph implementation of the research workflow
  - `lmstudio.py`: LMStudio integration
  - `prompts.py`: LLM prompt templates
  - `state.py`: State management for the research workflow
  - `utils.py`: Utility functions for web search, content processing, etc.

## Dependencies

The project relies on the following key dependencies:

```
langgraph>=0.2.55
langchain-community>=0.3.9
tavily-python>=0.5.0
langchain-ollama>=0.2.1
langchain_groq>=0.3.2
duckduckgo-search>=7.3.0
langchain-openai>=0.1.1
openai>=1.12.0
langchain_openai>=0.3.9
httpx>=0.28.1
markdownify>=0.11.0
python-dotenv==1.0.1
```

## Installation Instructions

### For Users (High-Level Usage)

1. **Prerequisites**:
   - Install Python 3.9+ (3.11 recommended)
   - Install Ollama or LMStudio for local LLM hosting

2. **Clone the Repository**:
   ```shell
   git clone https://github.com/langchain-ai/local-deep-researcher.git
   cd local-deep-researcher
   ```

3. **Configure Environment**:
   ```shell
   cp .env.example .env
   ```
   Edit the `.env` file to customize your setup (LLM provider, model, search API, etc.)

4. **Setup Local LLM**:
   
   For Ollama:
   - Download Ollama from [ollama.com/download](https://ollama.com/download)
   - Pull a model: `ollama pull deepseek-r1:8b` (or another model of your choice)
   
   For LMStudio:
   - Download and install LMStudio from [lmstudio.ai](https://lmstudio.ai/)
   - Download and load your preferred model
   - Start the server with the OpenAI-compatible API

5. **Launch the Application**:
   
   Using UV package manager (recommended):
   ```shell
   curl -LsSf https://astral.sh/uv/install.sh | sh
   uvx --refresh --from "langgraph-cli[inmem]" --with-editable . --python 3.11 langgraph dev
   ```
   
   Alternative method:
   ```shell
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\Activate.ps1
   pip install -e .
   pip install -U "langgraph-cli[inmem]"
   langgraph dev
   ```

6. **Access the UI**:
   Open the LangGraph Studio UI link provided in the terminal (typically `https://smith.langchain.com/studio/?baseUrl=http://127.0.0.1:2024`)

### For Developers (Contributing)

1. Follow the steps above to set up the basic environment
2. Install development dependencies:
   ```shell
   pip install -e ".[dev]"
   ```
3. Use ruff for linting:
   ```shell
   ruff check .
   ```

## User Interaction

Users interact with Local Deep Researcher through the LangGraph Studio UI. The process is:

1. Enter a research topic in the input field
2. Configure research parameters (optional)
3. Start the research process
4. View the visualization of the research workflow in real-time
5. Access the final research summary with sources

## Docker Deployment

The project can be deployed as a Docker container:

1. Build the image:
   ```shell
   docker build -t local-deep-researcher .
   ```

2. Run the container:
   ```shell
   docker run --rm -it -p 2024:2024 \
     -e SEARCH_API="duckduckgo" \
     -e LLM_PROVIDER=ollama \
     -e OLLAMA_BASE_URL="http://host.docker.internal:11434/" \
     -e LOCAL_LLM="llama3.2" \
     local-deep-researcher
   ```

3. Access the UI at: `https://smith.langchain.com/studio/thread?baseUrl=http://127.0.0.1:2024`

## Contributing Guidelines

While explicit contributing rules aren't specified in the project files, standard open-source contribution practices apply:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run linting with ruff
5. Submit a pull request

The project uses ruff for linting with specific configuration set in `pyproject.toml`.

## Sources & Inference

This documentation was created based on information inferred from the following files:

- `/home/jalcocert/Desktop/local-deep-researcher/README.md`: Primary source for project overview, features, and usage instructions
- `/home/jalcocert/Desktop/local-deep-researcher/.env.example`: Configuration options and environment variables
- `/home/jalcocert/Desktop/local-deep-researcher/pyproject.toml`: Dependencies and build system configuration
- `/home/jalcocert/Desktop/local-deep-researcher/src/ollama_deep_researcher/`: Source code structure and implementation details

## Browser Compatibility

- Firefox is recommended for the best experience
- Safari users may encounter security warnings due to mixed content (HTTPS/HTTP)
- If you encounter issues, try:
  1. Using Firefox or another browser
  2. Disabling ad-blocking extensions
  3. Checking browser console for specific error messages
