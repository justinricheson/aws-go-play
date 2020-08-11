ROOT_DIR := $(abspath ./)
BUILD_DIR := $(ROOT_DIR)/build
TOOLS_DIR := $(BUILD_DIR)/tools
COVERAGE_DIR := $(BUILD_DIR)/coverage

.PHONY: build build-stripped clean coverage format format-check lint test tidy

build:
	@echo "--> building project"
	go build -v -o $(BUILD_DIR)/app ./...

build-stripped:
	@echo "--> building project"
	go build -ldflags="-s -w" -v -o $(BUILD_DIR)/app ./...

clean:
	@echo "--> cleaning project"
	go clean -v -i -r
	rm -rf build/

coverage:
	@echo "--> generating code coverage report"
	mkdir -p $(COVERAGE_DIR)
	go test -coverprofile $(COVERAGE_DIR)/coverage.out ./...
	go tool cover -html=$(COVERAGE_DIR)/coverage.out -o $(COVERAGE_DIR)/coverage.html

format:
	@echo "--> formatting code"
	GOBIN=$(TOOLS_DIR) go install github.com/golangci/golangci-lint/cmd/golangci-lint
	$(TOOLS_DIR)/golangci-lint run -v --disable-all --enable=goimports --fix

format-check:
	@echo "--> checking code formatting"
	GOBIN=$(TOOLS_DIR) go install github.com/golangci/golangci-lint/cmd/golangci-lint
	$(TOOLS_DIR)/golangci-lint run -v --disable-all --enable=goimports

lint:
	@echo "--> linting code"
	GOBIN=$(TOOLS_DIR) go install github.com/golangci/golangci-lint/cmd/golangci-lint
	$(TOOLS_DIR)/golangci-lint run -v

test:
	@echo "--> running unit tests"
	go test ./...

tidy:
	@echo "--> tidying project"
	go mod tidy