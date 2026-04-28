# riscv-single-cycle-cpu

A learning-oriented Verilog project for building the smallest useful RISC-V
single-cycle CPU.

Now the goal is to connect those ideas into one real RTL system:

- program counter
- instruction fetch
- decode and control
- register file
- ALU
- data memory
- writeback
- branch / jump PC update

## Learning Goals

This repository is meant to help you understand:

- how a CPU datapath is assembled from smaller modules
- how control signals drive muxes and state updates
- how one instruction completes in one clock cycle in a single-cycle design
- how software concepts from `rv32-sim` map into hardware blocks
- how to test a CPU with a small hand-written program

## Supported Instruction Subset

This project starts with a small RV32I subset:

- `ADDI`
- `ADD`
- `SUB`
- `LW`
- `SW`
- `BEQ`
- `JAL`

That is enough to exercise:

- ALU operations
- register writeback
- load/store flow
- branch decisions
- jump control flow

## What The Demo Program Does

The built-in instruction ROM runs a tiny program that:

1. writes `5` into `x1`
2. writes `7` into `x2`
3. computes `x3 = x1 + x2`
4. stores `x3` into data memory address `0`
5. loads memory address `0` into `x5`
6. compares `x3` and `x5` with `BEQ`
7. skips a wrong-path instruction if the branch is taken
8. writes `1` into `x6`
9. jumps into a self-loop so simulation can stop cleanly

If the CPU is working:

- `x3` should become `12`
- memory word `0` should become `12`
- `x5` should become `12`
- `x6` should become `1`
- `x4` should stay `0` because the branch skips its write

## Build And Run

### Prerequisites

You need Icarus Verilog:

```bash
iverilog -V
```

### Run the CPU testbench

```bash
make test
```

This will:

- compile the CPU
- run the demo program in simulation
- dump a waveform into `waves/riscv_single_cycle_cpu.vcd`
- fail if the final architectural state is wrong
