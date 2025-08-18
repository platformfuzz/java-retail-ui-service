.PHONY: help install build test lint serve docker-build docker-run docker-test clean

# Default port configuration
PORT ?= 8080

help: ## Show this help message
	@echo "Retail UI Service - Development Commands"
	@echo "========================================"
	@echo "Default port: ${PORT}"
	@echo "Override with: make PORT=9090 docker-run"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	./mvnw dependency:resolve

build: ## Build the UI application
	./mvnw --no-transfer-progress -DskipTests package

test: ## Run tests
	./mvnw test -DexcludedGroups=integration

test-integration: ## Run integration tests
	./mvnw test -Dgroups=integration

lint: ## Run linting
	./mvnw checkstyle:checkstyle

serve: ## Start development server
	./mvnw spring-boot:run

docker-build: ## Build Docker image
	docker build -t retail-ui:local .

docker-run: ## Run Docker container
	docker run -p ${PORT}:${PORT} -e PORT=${PORT} retail-ui:local

docker-test: ## Test Docker container
	docker run -d --name test-container -e PORT=${PORT} retail-ui:local
	sleep 10
	docker inspect test-container --format='{{.State.Health.Status}}'
	docker stop test-container
	docker rm test-container

docker-compose-up: ## Start services with Docker Compose
	PORT=${PORT} docker-compose up -d

docker-compose-down: ## Stop services with Docker Compose
	docker-compose down

docker-compose-logs: ## View Docker Compose logs
	docker-compose logs -f

clean: ## Clean build artifacts
	./mvnw clean
	docker system prune -f

dev-setup: ## Setup development environment
	@echo "Setting up development environment..."
	@echo "1. Install dependencies..."
	./mvnw dependency:resolve
	@echo "2. Build application..."
	./mvnw --no-transfer-progress -DskipTests package
	@echo "3. Run tests..."
	./mvnw test -DexcludedGroups=integration
	@echo "4. Start development server..."
	@echo "Run 'make serve' to start the dev server"
	@echo "Run 'make docker-build' to build Docker image"
	@echo "Run 'make docker-compose-up' to start with Docker Compose"


