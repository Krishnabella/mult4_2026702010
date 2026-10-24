`timescale 1ns/1ps

module tb_mult_gls;
    reg clk, rst_n;
    reg [3:0] a, b;
    wire [7:0] p;
    integer i, j, errors, vectors;

    mult_array dut (
        .clk(clk), .rst_n(rst_n),
        .a(a), .b(b), .p(p)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("gls.vcd");
        $dumpvars(0, tb_mult_gls);

        errors = 0;
        vectors = 0;
        a = 0;
        b = 0;
        rst_n = 0;

        repeat (2) @(negedge clk);
        rst_n = 1;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                @(negedge clk);
                a = i;
                b = j;

                // Input register captures at the next rising edge.
                @(posedge clk);
                // Output register captures the corresponding product
                // at the following rising edge.
                @(posedge clk);
                #2;

                vectors = vectors + 1;
                if (p !== (i * j)) begin
                    $display("MISMATCH: a=%0d b=%0d expected=%0d got=%0d",
                             i, j, i*j, p);
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0)
            $display("PASS: %0d vectors checked, 0 errors", vectors);
        else
            $display("FAIL: %0d errors out of %0d vectors", errors, vectors);

        $finish;
    end
endmodule
