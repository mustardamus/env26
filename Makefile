.PHONY: default help dev_build dev_reset dev format format_all prod_build prod deploy
.DEFAULT_GOAL := dev

help: ## Show this help screen
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

dev_build: ## Build development container image
	@bash ./env/dev/run.sh build

dev_reset: ## Delete development container, images and volumes
	@bash ./env/dev/run.sh reset

dev: ## Run development environment
	@bash ./env/dev/run.sh dev

format: ## Format changed and uncommitted files
	@bash ./env/dev/format.sh

format_all: ## Format all files in the project
	@bash ./env/dev/format.sh all
