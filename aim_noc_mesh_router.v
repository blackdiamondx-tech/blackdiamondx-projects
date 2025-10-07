module AIM_NoC_Router #(
    parameter DATA_WIDTH = 64
)(
    input clk,
    input reset,
    // Neighbor ports
    input  [DATA_WIDTH-1:0] in_n, in_s, in_e, in_w,
    output [DATA_WIDTH-1:0] out_n, out_s, out_e, out_w,
    // Local core interface
    input  [DATA_WIDTH-1:0] local_in,
    output [DATA_WIDTH-1:0] local_out
);

    // Registers for buffering (expand for pipelining/arb)
    reg [DATA_WIDTH-1:0] buf_n, buf_s, buf_e, buf_w, buf_local;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buf_n <= 0; buf_s <= 0; buf_e <= 0; buf_w <= 0; buf_local <= 0;
        end else begin
            // Example: local_in to north, in_n to local, passthrough others
            buf_n     <= local_in;
            buf_local <= in_n;
            buf_s     <= in_s;
            buf_e     <= in_e;
            buf_w     <= in_w;
        end
    end
    assign out_n     = buf_n;
    assign out_s     = buf_s;
    assign out_e     = buf_e;
    assign out_w     = buf_w;
    assign local_out = buf_local;

    // For production: implement XY routing, buffering, arbitration, error-check.
endmodule