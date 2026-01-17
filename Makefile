# Heliosphere Build System

.PHONY: all grn-1kw sim clean

all: grn-1kw sim

grn-1kw:
	@echo "Building 1-kW GRN BOM..."
	@echo "Components:"
	@echo "- 10 m² rectenna film: $$500"
	@echo "- GaAs Schottky diodes: $$200"
	@echo "- DC-DC converter: $$150"
	@echo "Total: $$850"

sim:
	@echo "Running simulations..."
	python3 sim/beam_trace.py

clean:
	@echo "Cleaning build artifacts..."
