// AI Microprocessor Core Module with ALU, SIMD, NPU, TPU, and control
module AI_Core(
    input clk,
    input reset,
    input [31:0] instr,
    input [31:0] data_in,
    input power_enable,
    input [3:0] dvfs_level,
    output reg [31:0] result,
    output reg done
);
    wire [31:0] alu_result, simd_result, npu_result, tpu_result;
    wire is_alu  = (instr[3:0] == 4'b0001);
    wire is_simd = (instr[3:0] == 4'b0010);
    wire is_npu  = (instr[3:0] == 4'b0011);
    wire is_tpu  = (instr[3:0] == 4'b0100);

    ALU alu1 (.clk(clk), .reset(reset), .enable(power_enable & is_alu), .A(data_in), .B(data_in), .op(instr[7:4]), .result(alu_result));
    SIMD_Unit simd1 (.clk(clk), .reset(reset), .enable(power_enable & is_simd), .A(data_in), .op(instr[7:4]), .result(simd_result));
    NPU npu1 (.clk(clk), .reset(reset), .enable(power_enable & is_npu), .A(data_in), .op(instr[7:4]), .result(npu_result));
    TPU_Accelerator tpu1 (.clk(clk), .reset(reset), .enable(power_enable & is_tpu), .A(data_in), .op(instr[7:4]), .result(tpu_result));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 32'b0;
            done <= 1'b0;
        end else if (power_enable) begin
            if (is_alu) begin
                result <= alu_result;
                done <= 1'b1;
            end else if (is_simd) begin
                result <= simd_result;
                done <= 1'b1;
            end else if (is_npu) begin
                result <= npu_result;
                done <= 1'b1;
            end else if (is_tpu) begin
                result <= tpu_result;
                done <= 1'b1;
            end else begin
                result <= 32'b0;
                done <= 1'b0;
            end
        end else begin
            result <= 32'b0;
            done <= 1'b0;
        end
    end
endmodule
