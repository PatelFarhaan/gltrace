SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

PROJECT := gltrace
SCRIPT := ./gltrace

.PHONY: help run usage check deps fmt install-local test

help: ## Show all commands
	@echo "$(PROJECT) - available make targets"
	@echo
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_.-]+:.*##/ {printf "  %-14s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

usage: ## Show CLI usage
	@$(SCRIPT) --help

check: ## Validate required core dependencies (curl, jq)
	@command -v curl >/dev/null || (echo "Missing: curl" && exit 1)
	@command -v jq >/dev/null || (echo "Missing: jq" && exit 1)
	@echo "OK: curl + jq present"

deps: ## Show dependency status (gum needed for no-args wizard; fzf optional)
	@command -v gum >/dev/null && echo "OK: gum" || echo "Missing: gum (gltrace can attempt auto-install in wizard mode)"
	@command -v fzf >/dev/null && echo "OK: fzf" || echo "Missing (optional): fzf"

run: ## Run pipeline mode (requires env: GITLAB_URL, GITLAB_PROJECT_ID, GITLAB_TOKEN, PIPELINE_ID)
	@test -n "$$PIPELINE_ID" || (echo "Set PIPELINE_ID=<id>" && exit 1)
	@$(SCRIPT) --pipeline-id "$$PIPELINE_ID"

test: ## Smoke test: show help and ensure script is executable
	@test -x $(SCRIPT) || (echo "Script is not executable: $(SCRIPT)" && exit 1)
	@$(SCRIPT) --help >/dev/null
	@echo "OK: smoke test passed"

install-local: ## Install script to ~/.local/bin/gltrace
	@mkdir -p "$$HOME/.local/bin"
	@cp $(SCRIPT) "$$HOME/.local/bin/gltrace"
	@chmod +x "$$HOME/.local/bin/gltrace"
	@echo "Installed: $$HOME/.local/bin/gltrace"
	@echo "Make sure $$HOME/.local/bin is in your PATH"

fmt: ## Basic shell format check (if shfmt is installed)
	@command -v shfmt >/dev/null && shfmt -w $(SCRIPT) || echo "shfmt not installed, skipping"
