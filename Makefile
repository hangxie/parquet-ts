.DEFAULT_GOAL=help

# Required for globs to work correctly
SHELL:=/bin/bash

BUILD_DIR   = $(CURDIR)/build
NPM        ?= npm

TESTDATA_DIR     = $(BUILD_DIR)/testdata
# Pinned so an upstream commit cannot change or break CI without a change here.
PARQUET_TESTING_REF = e7bea05fa5bc18a032f3687e8a71128f14bb7331
PARQUET_TESTING  = https://raw.githubusercontent.com/apache/parquet-testing/$(PARQUET_TESTING_REF)/data
TESTDATA_FILES   = $(TESTDATA_DIR)/alltypes_plain.parquet \
                   $(TESTDATA_DIR)/nested_lists.snappy.parquet \
                   $(TESTDATA_DIR)/nested_maps.snappy.parquet \
                   $(TESTDATA_DIR)/nullable.impala.parquet \
                   $(TESTDATA_DIR)/repeated_no_annotation.parquet

.PHONY: all
all: deps format lint test build  ## Build all common targets

.PHONY: deps
deps: node_modules  ## Install prerequisite for build

# Fails closed: a lockfile that disagrees with package.json is an error, never
# a silent re-resolve, so a tagged commit always builds what it declares.
node_modules: package.json package-lock.json
	@echo "==> Installing dependencies"
	@$(NPM) ci --no-audit --no-fund
	@touch node_modules

.PHONY: deps-update
deps-update:  ## Re-resolve dependencies and update the lockfile
	@echo "==> Updating dependencies"
	@$(NPM) install --no-audit --no-fund

.PHONY: format
format: deps  ## Format all source code
	@echo "==> Formatting all source code"
	@$(NPM) run --silent format

.PHONY: lint
lint: deps  ## Run static code analysis
	@echo "==> Running static code analysis"
	@$(NPM) run --silent lint

.PHONY: test
test: deps  ## Run unit tests with coverage
	@echo "==> Running unit tests"
	@$(NPM) run --silent test:coverage

.PHONY: test-compat
test-compat: deps testdata  ## Run interoperability tests against apache/parquet-testing
	@echo "==> Running interoperability tests"
	@$(NPM) exec --silent -- vitest run tests/compatibility --passWithNoTests

.PHONY: testdata
testdata:  ## Download test data from apache/parquet-testing
	@mkdir -p $(TESTDATA_DIR)
	@for f in $(TESTDATA_FILES); do \
		if [ ! -f "$$f" ]; then \
			echo "    ==> Downloading $$(basename $$f)"; \
			curl -sSfL -o "$$f" "$(PARQUET_TESTING)/$$(basename $$f)"; \
		fi; \
	done

.PHONY: build
build: deps  ## Compile the package to dist/
	@echo "==> Compiling package"
	@$(NPM) run --silent build

.PHONY: benchmark
benchmark: deps  ## Run benchmark
	@echo "==> Running benchmark"
	@$(NPM) exec --silent -- vitest bench --run

.PHONY: clean
clean:  ## Clean up the build dirs
	@echo "==> Cleaning up build dirs"
	@rm -rf $(BUILD_DIR) dist node_modules

.PHONY: help
help:  ## Print list of Makefile targets
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f1- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
