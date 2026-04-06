# RV32I Single-Cycle Core

A single-cycle RTL implementation of the RISC-V RV32I base integer instruction set in Verilog.

## Overview

This project implements a 32-bit RISC-V processor supporting the full RV32I instruction set using a single-cycle microarchitecture.

Each instruction completes in one clock cycle.

The design was developed to understand ISA-to-RTL translation, datapath construction, and control unit design.

---

## Supported Instruction Types

- R-Type (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU)
- I-Type (ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI)
- Load (LW)
- Store (SW)
- Branch (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- U-Type (LUI, AUIPC)
- Jump (JAL, JALR)

---

## Architecture

The processor consists of:

- Program Counter (PC)
- Instruction Memory
- Register File (32 × 32)
- ALU
- Immediate Generator
- Data Memory
- Control Unit
- Branch and Jump Logic

Single-cycle datapath implementation.

---

## Design Features

- Fully combinational datapath
- Modular RTL design
- Parameterized ALU control
- Clean separation between datapath and control logic
- Synthesizable Verilog

---

## Tools Used

- Verilog HDL
- ModelSim / QuestaSim (Simulation)
- GTKWave (Waveform Analysis)

---



