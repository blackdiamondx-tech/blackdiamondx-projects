`timescale 1ns/1ps

module tb_aim_noc_mesh_router;
    reg clk, reset;
    reg [63:0] in_n, in_s, in_e, in_w, local_in;
    wire [63:0] out_n, out_s, out_e, out_w, local_out;

    AIM_NoC_Router #(64) uut (
        .clk(clk), .reset(reset),
        .in_n(in_n), .in_s(in_s),
        .in_e(in_e), .in_w(in_w),
        .out_n(out_n), .out_s(out_s),
        .out_e(out_e), .out_w(out_w),
        .local_in(local_in), .local_out(local_out)
    );

    initial begin
        clk = 0; reset = 1;
        in_n = 64'h0; in_s = 64'h0; in_e = 64'h0; in_w = 64'h0;
        local_in = 64'hABCD12345678EF00;
        #5 reset = 0;

        // Send data from local_in to north
        #10 $display("out_n = %h, local_out = %h", out_n, local_out);

        // Send data from north to local
        in_n = 64'h1111222233334444;
        #10 $display("out_n = %h, local_out = %h", out_n, local_out);

        $finish;
    end

    always #5 clk = ~clk;
endmodule
