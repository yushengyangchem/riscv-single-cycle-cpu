# Roadmap

This repository is the bridge between Verilog basics and a real RTL CPU.

## Phase 1: Read The Existing CPU End To End

Goal: be able to explain the current single-cycle datapath from memory.

Make sure you can answer:

- where does the instruction come from?
- when does the PC update?
- how does the control unit choose ALU and writeback behavior?
- how does `BEQ` redirect the PC?
- how does `JAL` differ from a normal sequential instruction?

## Phase 2: Add Small ISA Extensions

Good next instructions to add:

- `AND`
- `OR`
- `XOR`
- `SLT`
- `BNE`
- `JALR`

Each new instruction should come with:

- decode logic
- datapath support if needed
- one focused testbench check

## Phase 3: Make The Verification Better

Improve confidence by adding:

- more small ROM programs
- edge-case branch tests
- negative immediates
- store/load with non-zero addresses
- reset behavior checks

## Phase 4: Prepare For The Next CPU Project

After this single-cycle CPU, a strong next step is:

- multi-cycle CPU
- simple pipeline
- instruction/data memory split cleanup
- memory-mapped I/O or accelerator registers
