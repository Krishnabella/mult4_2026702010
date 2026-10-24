`timescale 1ns/1ps

module tb_mult_example;
    reg clk = 0;
    reg rst_n = 0;
    reg [3:0] a = 0, b = 0;
    wire [7:0] p;

    mult_array dut (
        .clk(clk), .rst_n(rst_n),
        .a(a), .b(b), .p(p)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mult_example.vcd");
        $dumpvars(0, tb_mult_example);

        repeat (2) @(negedge clk);
        rst_n = 1;

        @(negedge clk);
        a = 4'd5;
        b = 4'd7;
        $display("Applied A=5, B=7; expected product=35");

        @(posedge clk);
        #1;
        $display("After rising edge 1: p=%0d", p);

        @(posedge clk);
        #1;
        $display("After rising edge 2: p=%0d", p);

        if (p === 8'd35)
            $display("PASS: 5 x 7 = 35 after two rising edges");
        else
            $display("FAIL: expected 35, got %0d", p);

        $finish;
    end
endmodule
