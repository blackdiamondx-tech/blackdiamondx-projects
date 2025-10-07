module AIM_AXI_Regs #(
    parameter DATA_WIDTH = 32
)(
    input clk,
    input reset,
    // AXI-Lite slave interface
    input [3:0]  awaddr,
    input        awvalid,
    output       awready,
    input [3:0]  wstrb,
    input [DATA_WIDTH-1:0] wdata,
    input        wvalid,
    output       wready,
    output [1:0] bresp,
    output       bvalid,
    input        bready,
    input [3:0]  araddr,
    input        arvalid,
    output       arready,
    output [DATA_WIDTH-1:0] rdata,
    output [1:0] rresp,
    output       rvalid,
    input        rready,
    // To/From AI core
    output reg [31:0] instr_out,
    output reg [31:0] data_out,
    input      [31:0] result_in,
    input             result_valid
);
    // Register map: 0=instr, 4=data, 8=result, C=status
    reg [31:0] instr_reg, data_reg, result_reg;
    reg        status_reg;

    assign awready = 1; assign wready = 1; assign bresp = 2'b00; assign bvalid = 1;
    assign arready = 1; assign rresp = 2'b00; assign rvalid = 1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr_reg <= 0; data_reg <= 0; result_reg <= 0; status_reg <= 0;
        end else begin
            // Write
            if (awvalid && wvalid) begin
                case (awaddr)
                    4'h0: instr_reg <= wdata;
                    4'h4: data_reg  <= wdata;
                endcase
            end
            // Writeback result from AI core
            if (result_valid) begin
                result_reg <= result_in;
                status_reg <= 1;
            end
            // Clear status on read
            if (arvalid && araddr == 4'hC && rready) status_reg <= 0;
        end
    end
    assign rdata = (araddr == 4'h0) ? instr_reg :
                   (araddr == 4'h4) ? data_reg  :
                   (araddr == 4'h8) ? result_reg :
                   (araddr == 4'hC) ? {31'b0, status_reg} : 32'b0;

    // Output signals to AI core
    always @(*) begin
        instr_out = instr_reg;
        data_out  = data_reg;
    end
endmodule