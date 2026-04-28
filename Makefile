# ==========================================
# riscv-single-cycle-cpu Makefile
# ==========================================

IVERILOG = iverilog
VVP = vvp
IVERILOG_FLAGS = -g2012 -Wall
BUILD_DIR = build
WAVE_DIR = waves

RTL_SRCS = \
	rtl/core/alu.sv \
	rtl/core/control_unit.sv \
	rtl/core/data_memory.sv \
	rtl/core/immediate_gen.sv \
	rtl/core/instruction_memory.sv \
	rtl/core/program_counter.sv \
	rtl/core/register_file.sv \
	rtl/top/riscv_single_cycle_cpu.sv

TB_SRCS = tb/riscv_single_cycle_cpu_tb.sv

.PHONY: all clean test sim

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(WAVE_DIR):
	mkdir -p $(WAVE_DIR)

sim: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) $(IVERILOG_FLAGS) -o $(BUILD_DIR)/cpu.out $(RTL_SRCS) $(TB_SRCS)
	$(VVP) $(BUILD_DIR)/cpu.out

test: sim

clean:
	rm -rf $(BUILD_DIR) $(WAVE_DIR)

