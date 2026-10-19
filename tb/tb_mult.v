`timescale 1ns/1ps

module tb_mult;

    reg        clk;
    reg        rst_n;
    reg [3:0]  a;
    reg [3:0]  b;

    wire [7:0] p;

    integer i;
    integer j;
    integer errors;
    integer vectors;

    mult_array dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .p(p)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Waveform dump
    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);
    end

    initial begin

        errors  = 0;
        vectors = 0;

        a     = 4'b0000;
        b     = 4'b0000;
        rst_n = 1'b0;

        // Reset low for two clock cycles
        repeat (2) @(posedge clk);

        rst_n = 1'b1;

        // Exhaustive test: 16 x 16 = 256 combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin

                a = i;
                b = j;

                // Required 2-cycle latency
                @(posedge clk);
                @(posedge clk);

                #1;

                vectors = vectors + 1;

                if (p !== (i * j)) begin
                    $display(
                        "MISMATCH: a=%0d b=%0d expected=%0d got=%0d",
                        i, j, (i * j), p
                    );
                    errors = errors + 1;
                end

            end
        end

        if (errors == 0)
            $display("PASS: 256 vectors checked, 0 errors");
        else
            $display("FAIL: %0d errors out of 256 vectors", errors);

        $finish;

    end

endmodule