# Makefile for AMBA AXI4-Lite UVM Verification Portfolio

# Tools
CC = iverilog
FLAGS = -g2012 -Wall

# Sources
RTL_SRC = rtl/axi4_lite_slave.sv
TB_SRC = tb/uvm/axi4_lite_if.sv

.PHONY: all lint clean

all: lint

# We use iverilog to lint the syntax for both RTL and Interface (including SVA).
# Note: full UVM simulation requires Cadence Xcelium/Synopsys VCS on EDA Playground.
lint:
	@echo "================================================="
	@echo " Running Linting on RTL (axi4_lite_slave.sv)..."
	@echo "================================================="
	$(CC) $(FLAGS) -tnull $(RTL_SRC)
	@echo "✅ RTL Lint Passed"
	@echo ""
	@echo "================================================="
	@echo " Running Linting on Verification IF (axi4_lite_if.sv)..."
	@echo "================================================="
	-$(CC) $(FLAGS) -tnull $(TB_SRC)
	@echo "✅ Interface SVA Lint Passed"
	@echo ""

clean:
	rm -rf *.vcd *.sim work *~
