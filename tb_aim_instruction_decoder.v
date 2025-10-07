`timescale 1ns/1ps

module tb_aim_instruction_decoder;
    reg  [31:0] instr;
    wire        is_ai, is_graphics;
    wire [5:0]  opcode;
    wire [3:0]  ai_type, gfx_type;
    wire [7:0]  src_reg, dst_reg, imm;

    AIM_InstructionDecoder uut (
        .instr(instr),
        .is_ai(is_ai),
        .is_graphics(is_graphics),
        .opcode(opcode),
        .ai_type(ai_type),
        .gfx_type(gfx_type),
        .src_reg(src_reg),
        .dst_reg(dst_reg),
        .imm(imm)
    );

    initial begin
        // AI instruction: 0x100A4321
        instr = 32'b0001_0000_1010_0100_0011_0010_0001_0001;
        #10;
        $display("AI: %b, Graphics: %b, opcode: %h, ai_type: %h, src_reg: %h, dst_reg: %h, imm: %h",
                 is_ai, is_graphics, opcode, ai_type, src_reg, dst_reg, imm);

        // Graphics instruction: 0x200B5678
        instr = 32'b0010_0000_1011_0101_0110_0111_1000_1000;
        #10;
        $display("AI: %b, Graphics: %b, opcode: %h, gfx_type: %h, src_reg: %h, dst_reg: %h, imm: %h",
                 is_ai, is_graphics, opcode, gfx_type, src_reg, dst_reg, imm);

        // Custom instruction
        instr = 32'hF1234567;
        #10;
        $display("AI: %b, Graphics: %b, opcode: %h", is_ai, is_graphics, opcode);

        $finish;
    end
endmodule
