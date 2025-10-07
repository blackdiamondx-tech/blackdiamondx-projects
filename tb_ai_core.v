`timescale 1ns/1ps

module tb_ai_core;
    reg clk, reset, power_enable;
    reg [31:0] instr, data_in;
    reg [3:0] dvfs_level;
    wire [31:0] result;
    wire done;

    AI_Core uut (
        .clk(clk), .reset(reset), .instr(instr), .data_in(data_in),
        .power_enable(power_enable), .dvfs_level(dvfs_level),
        .result(result), .done(done)
    );

    initial begin
        clk = 0; reset = 1; power_enable = 0;
        instr = 32'h00000000; data_in = 32'h00000000; dvfs_level = 4'b1010;
        #10 reset = 0; power_enable = 1;

        // Test ALU operation
        instr[3:0] = 4'b0001; // is_alu
        data_in = 32'h00000005;
        #20 $display("ALU Result: %h, Done: %b", result, done);

        // Test SIMD operation
        instr[3:0] = 4'b0010; // is_simd
        data_in = 32'h000000FF;
        #20 $display("SIMD Result: %h, Done: %b", result, done);

        // Test NPU operation
        instr[3:0] = 4'b0011; // is_npu
        data_in = 32'h0000F0F0;
        #20 $display("NPU Result: %h, Done: %b", result, done);

        // Test TPU operation
        instr[3:0] = 4'b0100; // is_tpu
        data_in = 32'h00FF00FF;
        #20 $display("TPU Result: %h, Done: %b", result, done);

        $finish;
    end

    always #5 clk = ~clk;
endmodule
