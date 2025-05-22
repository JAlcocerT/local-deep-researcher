# Use a slim Python 3.11 image as the base.
# 'bookworm' is the Debian release name for Python 3.11 slim images.
# --platform=$BUILDPLATFORM is good for multi-architecture builds.
FROM --platform=$BUILDPLATFORM python:3.11-slim-bookworm

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies required for building Python packages.
# Some Python packages, especially those with C extensions or Rust components (like parts of uv's ecosystem),
# require these build tools.
# curl and ca-certificates are useful for fetching resources.
# build-essential, python3-dev, libssl-dev, libffi-dev are for C extensions.
# rustc and cargo are for Rust-based Python packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    build-essential \
    python3-dev \
    libssl-dev \
    libffi-dev \
    rustc \
    cargo \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt file into the container for dependency installation
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Install the application itself
RUN pip install .

# Set environment variables
ENV LLM_PROVIDER=ollama \
    OLLAMA_BASE_URL=http://ollama:11434 \
    LOCAL_LLM=deepseek-r1:8b \
    SEARCH_API=duckduckgo \
    MAX_WEB_RESEARCH_LOOPS=3 \
    FETCH_FULL_PAGE=True \
    PAGER=cat

# Install LangGraph CLI
RUN pip install "langgraph-cli[inmem]>=0.0.18"

# Expose the port for LangGraph Studio
EXPOSE 2024

# Start the LangGraph server
CMD ["langgraph", "dev", "--host", "0.0.0.0"]

# FROM --platform=$BUILDPLATFORM python:3.11-slim

# WORKDIR /app

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     curl \
#     ca-certificates \
#     build-essential \
#     python3-dev \
#     libssl-dev \
#     libffi-dev \
#     rustc \
#     cargo \
#     && rm -rf /var/lib/apt/lists/*

# # Install uv package manager (use pip for safer cross-arch install)
# RUN pip install uv
# ENV PATH="/root/.local/bin:${PATH}"

# # 2) Copy the repository content
# COPY . /app

# # 3) Provide default environment variables to point to Ollama (running elsewhere)
# #    Adjust the OLLAMA_URL to match your actual Ollama container or service.
# ENV OLLAMA_BASE_URL="http://localhost:11434/"

# # 4) Expose the port that LangGraph dev server uses (default: 2024)
# EXPOSE 2024

# # 5) Launch the assistant with the LangGraph dev server:
# #    Equivalent to the quickstart: uvx --refresh --from "langgraph-cli[inmem]" --with-editable . --python 3.11 langgraph dev
# # CMD ["uvx", \
# #      "--refresh", \
# #      "--from", "langgraph-cli[inmem]", \
# #      "--with-editable", ".", \
# #      "--python", "3.11", \
# #      "langgraph", \
# #      "dev", \
# #      "--host", "0.0.0.0"]