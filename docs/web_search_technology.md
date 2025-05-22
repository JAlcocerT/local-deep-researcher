# Web Search Technology Overview

## Introduction to Web Search Technology

Web search technologies enable the Local Deep Researcher project to gather information from the internet based on generated queries. The project supports multiple search providers:

- [DuckDuckGo](https://duckduckgo.com/): Privacy-focused search engine with no API key required
- [Tavily](https://tavily.com/): AI-powered search API built for AI applications
- [Perplexity](https://www.perplexity.ai/): AI-powered search with advanced contextualization
- [SearXNG](https://docs.searxng.org/): Self-hosted, privacy-respecting metasearch engine

## Use Cases in Local Deep Researcher

The web search technologies serve critical functions in the research workflow:

1. **Information Gathering**: Retrieving relevant web content based on generated search queries
2. **Source Discovery**: Finding authoritative sources on research topics
3. **Content Retrieval**: Optionally fetching full page content for more comprehensive analysis
4. **Iterative Research**: Supporting multiple research cycles with refined queries

## Implementation Examples

The search functionality is primarily implemented in `utils.py`. Here are examples for different search providers:

```python
# From src/ollama_deep_researcher/utils.py - DuckDuckGo search implementation
def duckduckgo_search(query: str, max_results: int = 3, fetch_full_page: bool = False) -> List[dict]:
    """Search DuckDuckGo for the query and return results.
    
    Args:
        query: The search query
        max_results: Maximum number of results to return
        fetch_full_page: Whether to fetch the full page content
        
    Returns:
        List of search results with url, title, and content fields
    """
    try:
        ddg = DDGS()
        results = []
        
        for r in ddg.text(query, max_results=max_results):
            result = {
                "url": r["href"],
                "title": r["title"],
                "content": "",
            }
            
            if fetch_full_page:
                try:
                    result["content"] = fetch_url_content(r["href"])
                except Exception as e:
                    result["content"] = r.get("body", "")
                    print(f"Error fetching content for {r['href']}: {e}")
            else:
                result["content"] = r.get("body", "")
                
            results.append(result)
            
        return results
    except Exception as e:
        print(f"Error searching DuckDuckGo: {e}")
        return []
```

```python
# From src/ollama_deep_researcher/utils.py - Example of processing search results
def deduplicate_and_format_sources(sources: List[dict], max_tokens_per_source: int = 1000, fetch_full_page: bool = False) -> str:
    """Deduplicate and format sources for the LLM.
    
    Args:
        sources: List of search results
        max_tokens_per_source: Maximum number of tokens per source
        fetch_full_page: Whether full page content was fetched
        
    Returns:
        Formatted string of sources
    """
    # Implementation details for processing and formatting search results
    # ...
```

## Design Patterns

The web search implementation demonstrates several design patterns:

1. **Strategy Pattern**: Different search providers can be selected and swapped at runtime.
2. **Adapter Pattern**: Each search provider has a consistent interface despite different underlying APIs.
3. **Factory Method**: Search functionality is created based on configuration settings.
4. **Template Method**: Common processing steps are standardized across providers.

## Integration with Other Technologies

Web search technology integrates with:

- **LangGraph**: For incorporating search results into the research workflow
- **LLMs**: For generating queries and processing search results
- **Configuration System**: For selecting and configuring search providers
- **HTTP Clients**: For making web requests and processing responses

## Benefits for the Project

1. **Flexibility**: Supports multiple search providers with different strengths
2. **Privacy Options**: Includes privacy-focused options like DuckDuckGo and SearXNG
3. **No API Key Required**: Can function with DuckDuckGo without any API keys
4. **Depth Control**: Options for fetching full page content for more comprehensive research

## Technical Implementation Details

The web search implementation follows these key principles:

1. **Provider Abstraction**: The core application is unaware of which search provider is being used
2. **Content Processing**: Handles HTML content extraction and formatting
3. **Error Handling**: Robust error handling for network issues and provider-specific errors
4. **Source Deduplication**: Removes duplicate sources to improve research quality

For example, the project includes dedicated handling for full page content retrieval:

```python
# From src/ollama_deep_researcher/utils.py
def fetch_url_content(url: str) -> str:
    """Fetch the content of a URL.
    
    Args:
        url: The URL to fetch
        
    Returns:
        The content of the URL as text
    """
    try:
        response = httpx.get(url, timeout=10, follow_redirects=True)
        response.raise_for_status()
        
        # Get content type to determine how to handle the response
        content_type = response.headers.get("content-type", "").lower()
        
        # Handle HTML content
        if "text/html" in content_type:
            # Parse HTML and extract main content
            soup = BeautifulSoup(response.text, "html.parser")
            
            # Remove script and style elements
            for script in soup(["script", "style", "header", "footer", "nav"]):
                script.extract()
            
            # Get text content
            text = soup.get_text(separator=" ", strip=True)
            
            # Clean up text (remove extra whitespace, etc.)
            text = re.sub(r"\s+", " ", text).strip()
            
            return text
        
        # For other content types, just return the text
        return response.text
    except Exception as e:
        return f"Error fetching URL: {str(e)}"
```

The search functionality is central to the project's ability to conduct deep, iterative research on any topic, forming the foundation of its information gathering capabilities.
