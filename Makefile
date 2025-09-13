.PHONY: help up down build rebuild logs logs-service run-prod

# Display help for all available commands
help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@echo '  help         Show this help message'
	@echo '  up           Start all services in detached mode'
	@echo '  down         Stop and remove all services'
	@echo '  build        Rebuild the services with no cache'
	@echo '  rebuild      Rebuild and restart services'
	@echo '  logs         View logs for all services'
	@echo '  logs-service View logs for a specific service (e.g., make logs-service service=local-deep-researcher)'

# Start all services in detached mode
up: build
	docker compose -f docker-compose.dev.yml up -d

down: ## Stop and remove all services
	docker compose -f docker-compose.dev.yml down

# Rebuild the services
build:
	docker compose -f docker-compose.dev.yml build --no-cache

# Rebuild and restart services
rebuild: build up

# View logs for all services
logs:
	docker compose -f docker-compose.dev.yml logs -f

# View logs for a specific service (e.g., make logs-service service=local-deep-researcher)
logs-service:
	docker compose -f docker-compose.dev.yml logs -f $(service)

# Run in production mode with environment setup
run-prod:
	@if [ ! -f .env ]; then \
		echo "No .env file found. Creating from .env.prod.example..."; \
		cp .env.prod.example .env; \
		read -p "Enter your OpenAI API key: " OPENAI_KEY; \
		sed -i "s|OPENAI_API_KEY=.*|OPENAI_API_KEY=$$OPENAI_KEY|" .env; \
	fi; \
	uvx \
		--refresh \
		--from "langgraph-cli[inmem]" \
		--with-editable . \
		--python 3.11 \
		langgraph dev
