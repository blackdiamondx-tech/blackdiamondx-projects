# AIM Architectural Overview

## System Architecture

- **Unified Compute Cores**: Programmable for AI, graphics, or custom logic.
- **AI/Tensor Engines**: Hardware blocks for matrix multiply, convolution, etc.
- **NoC (Network-on-Chip)**: 2D mesh for scalable, high-bandwidth communication.
- **Hierarchical Memory**: Multi-level cache, shared SRAM, and HBM/DDR.
- **Scheduler & AI Controller**: Hardware/firmware for dynamic resource allocation, load balancing, and DVFS.
- **Host Agent/Driver**: Software bridge between host OS/applications and AIM hardware.

## Block Diagram (Textual)
```
[HOST]---[AGENT/DRIVER]---[SCHEDULER]---[NoC]---{CORES/TENSOR/FPGA}
                                |           |
                             [MEMORY]   [AI CTRL]
```

---

### Example Top-Level Verilog Module

```verilog
module AIM_Chip_Top(
    input clk,
    input reset,
    input [31:0] instr_in,
    input [31:0] data_in,
    output [31:0] result_out,
    output done
);
    wire [31:0] core_results[0:15];
    wire [15:0] core_done;
    wire [3:0] dvfs_level = 4'b1010;
    wire [15:0] power_enable = 16'hFFFF;

    // Scheduler
    Scheduler scheduler(
        .clk(clk), .reset(reset),
        .instr_in(instr_in), .data_in(data_in),
        .instr_out(instr_out), .data_out(data_out)
    );

    // Microprocessor Cores
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : CORES
            AI_Core core(
                .clk(clk), .reset(reset),
                .instr(instr_out), .data_in(data_out),
                .power_enable(power_enable[i]), .dvfs_level(dvfs_level),
                .result(core_results[i]), .done(core_done[i])
            );
        end
    endgenerate

    // Result collector (arbiter)
    assign result_out = |core_done ? core_results[$clog2(core_done)] : 32'b0;
    assign done = |core_done;
endmodule
```