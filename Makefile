# Directory containing Helm charts
CHARTS_DIR := charts

# Output directory for packaged charts
OUTPUT_DIR := releases

# URL of the Helm chart repository (replace with your actual repo URL)
REPO_URL := https://github.com/meshkat632/helm-charts

# Define the default target
.PHONY: all
all: package-all update-index

# Create the output directory
.PHONY: create-output-dir
create-output-dir:
	@mkdir -p $(OUTPUT_DIR)

# Package a single chart
.PHONY: package
package:
	@echo "Packaging chart: $(CHART_NAME)"
	helm package $(CHARTS_DIR)/$(CHART_NAME) -d $(OUTPUT_DIR)

# Package all charts in the charts directory
.PHONY: package-all
package-all: create-output-dir
	@for dir in $(shell ls -d $(CHARTS_DIR)/*/); do \
		CHART_NAME=$$(basename $$dir); \
		$(MAKE) package CHART_NAME=$$CHART_NAME; \
	done

# Update the index.yaml file
.PHONY: update-index
update-index: create-output-dir
	@echo "Updating index.yaml with REPO_URL=$(REPO_URL)"
	helm repo index $(OUTPUT_DIR) --url $(REPO_URL)

# Clean the output directory
.PHONY: clean
clean:
	@rm -rf $(OUTPUT_DIR)
	@echo "Cleaned $(OUTPUT_DIR)"
