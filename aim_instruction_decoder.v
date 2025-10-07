module AIM_InstructionDecoder(
    input  [31:0] instr,
    output        is_ai,
    output        is_graphics,
    output [5:0]  opcode,
    output [3:0]  ai_type,
    output [3:0]  gfx_type,
    output [7:0]  src_reg,
    output [7:0]  dst_reg,
    output [7:0]  imm
);
    // Type (AI: 0001, GFX: 0010)
    assign is_ai       = (instr[31:28] == 4'b0001);
    assign is_graphics = (instr[31:28] == 4'b0010);

    assign ai_type  = is_ai       ? instr[27:24] : 4'b0;
    assign gfx_type = is_graphics ? instr[27:24] : 4'b0;
    assign opcode   = instr[23:18];

    // Example: src_reg = bits [17:10], dst_reg = [9:2], imm = [7:0]
    assign src_reg = instr[17:10];
    assign dst_reg = instr[9:2];
    assign imm     = instr[7:0];
endmodule