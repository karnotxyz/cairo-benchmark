# Makefile for Cairo Project

# Function to declare a contract
# Usage: $(call declare_contract,contract_name,package_name)
define declare_contract
	@echo "Declaring contract $(1) from package $(2)..."
	@sncast --profile kkrt_staging_dev declare --fee-token eth --contract-name $(1) --package $(2) 2>/dev/null
endef


# Function to deploy a contract
# Usage: $(call deploy_contract,class_hash,package_name)
define deploy_contract
	@echo "Deploying contract $(1) from package $(2)..."
  $(eval CLASS_HASH := $(shell starkli class-hash $(3) 2>/dev/null))
  @echo "Deploying contract with class hash: $(CLASS_HASH)"
  @sncast --profile kkrt_staging_dev deploy --class-hash $(CLASS_HASH) --fee-token eth
	@echo "Contract $(1) successfully deployed ✅ "
endef


# Default target
all: build

# Build the project using Scarb
build:
	@scarb build 1> /dev/null

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
deploy: declare
	$(call deploy_contract,BenchmarkContract,benchmark_tests,./target/dev/benchmark_tests_BenchmarkContract.contract_class.json)
	$(call deploy_contract,SisterContract,benchmark_tests,./target/dev/benchmark_tests_SisterContract.contract_class.json)

declare:
	$(call declare_contract,BenchmarkContract,benchmark_tests)
	$(call declare_contract,SisterContract,benchmark_tests)

# Phony targets
.PHONY: all build test clean format check-format run docs
