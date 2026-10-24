`timescale 1ns/1ps

module tb_mult_error;
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
        repeat (2) @(negedge clk);
        rst_n = 1;

        @(negedge clk);
        a = 4'd5;
        b = 4'd7;

        repeat (2) @(posedge clk);
        #1;

        if (p !== 8'd34)
            $display("FAIL (expected negative test): expected=34, actual=%0d", p);
        else
            $display("UNEXPECTED PASS");

        $finish;
    end
endmodule
