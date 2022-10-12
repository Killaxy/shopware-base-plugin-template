.DEFAULT_GOAL := help

PLUGIN_ROOT=$(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)
PROJECT_ROOT=$(PLUGIN_ROOT)/../../..

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

phpstan: ## Run phpstan
	@if ! [ -d "$(PLUGIN_ROOT)/vendor" ]; then composer install ; fi
	@composer dump-autoload --dev
	@php $(PLUGIN_ROOT)/vendor/bin/phpstan analyze --configuration $(PLUGIN_ROOT)/phpstan.neon.dist --autoload-file $(PROJECT_ROOT)/vendor/autoload.php
.PHONY: phpstan

phpunit: ## Run phpunit
	@composer dump-autoload --dev
	@php $(options) $(PROJECT_ROOT)/vendor/bin/phpunit $(test)
.PHONY: phpunit

phpunit-coverage: ## Run phpunit with coverage report
	@make phpunit options="$(options) -d xdebug.mode=coverage" test="--coverage-html coverage --coverage-clover clover.xml $(test)"
.PHONY: phpunit-coverage
