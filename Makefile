# Makefile for Cairo Project
# Variables
CONTRACT_NAME ?= BenchmarkContract
PACKAGE_NAME ?= benchmark_tests

# Default target
all: build

# Build the project using Scarb
build:
	@scarb build

# Run tests
test:
	scarb test

# Clean the project
clean:
	scarb clean

# Format the code
format:
	scarb fmt

# Check the format without modifying files
check-format:
	scarb fmt --check

# Run the project (assuming there's a main file to run)
run:
	scarb run

# Generate documentation
docs:
	scarb doc

# Deploy contract
declare: build
	@echo "Declaring contract $(CONTRACT_NAME) from package $(PACKAGE_NAME)..."
	@sncast --profile development declare --fee-token eth --contract-name $(CONTRACT_NAME) --package $(PACKAGE_NAME) 2>/dev/null
	

# Deploy contract
deploy:build declare
	$(eval CLASS_HASH := $(shell starkli class-hash ./target/dev/benchmark_tests_BenchmarkContract.contract_class.json))
	@echo "Deploying contract with class hash: $(CLASS_HASH)"
	@sncast --profile development deploy --class-hash $(CLASS_HASH) --fee-token eth

# Phony targets
.PHONY: all build test clean format check-format run docs
