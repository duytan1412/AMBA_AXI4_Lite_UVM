# Makefile for AXI4-Lite Slave RTL & ABV Verification

# Tools
CC = iverilog
FLAGS = -g2012 -Wall
VVP = vvp

# Sources
RTL_SRC = rtl/axi4_lite_slave.sv
TB_IF  = tb/if/axi4_lite_if.sv
TB_TOP = tb/axi4_lite_simple_tb.sv

OUT = axi_sim.vvp
VCD = dump.vcd

.PHONY: all lint sim waves clean

all: sim

# Lint checks for syntax and basic SVA structure
lint:
	@echo "--- Running RTL & IF Lint ---"
	$(CC) $(FLAGS) -tnull $(RTL_SRC) $(TB_IF)
	@echo "✅ Lint Passed"

# Full simulation: Compile and run testbench
sim: $(RTL_SRC) $(TB_IF) $(TB_TOP)
	@echo "--- Compiling AXI4-Lite Verification Environment ---"
	$(CC) $(FLAGS) -o $(OUT) $(RTL_SRC) $(TB_IF) $(TB_TOP)
	@echo "--- Running Simulation ---"
	$(VVP) $(OUT)
	@echo "✅ Simulation Finished"

# Open waveform in GTKWave
waves: $(VCD)
	gtkwave $(VCD)

clean:
	rm -rf $(OUT) $(VCD) *.sim *~
