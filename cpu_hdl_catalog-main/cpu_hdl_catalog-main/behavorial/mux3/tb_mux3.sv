`timescale 1ns/100ps

module tb_mux3();

    logic [31:0] w32_d0, w32_d1, w32_d2;
    logic [1:0]  w32_s;
    logic [31:0] w32_y;

    mux3 #(.WIDTH(32)) dut_32bit (
        .d0(w32_d0),
        .d1(w32_d1),
        .d2(w32_d2),
        .s(w32_s),
        .y(w32_y)
    );

    logic [4:0]  w5_d0, w5_d1, w5_d2;
    logic [1:0]  w5_s;
    logic [4:0]  w5_y;

    mux3 #(.WIDTH(5)) dut_5bit (
        .d0(w5_d0),
        .d1(w5_d1),
        .d2(w5_d2),
        .s(w5_s),
        .y(w5_y)
    );

    initial begin
        // 32 bit test cases
        w32_d0 = 32'hAAAA_AAAA;
        w32_d1 = 32'hBBBB_BBBB;
        w32_d2 = 32'hCCCC_CCCC;

        w32_s = 2'b00; #5;
        $display("t=%0t | 32-bit Mux [S=00] - Out: 0x%h (Expect AAAAAAAA)", $time, w32_y);

        w32_s = 2'b01; #5;
        $display("t=%0t | 32-bit Mux [S=01] - Out: 0x%h (Expect BBBBBBBB)", $time, w32_y);

        w32_s = 2'b10; #5;
        $display("t=%0t | 32-bit Mux [S=10] - Out: 0x%h (Expect CCCCCCCC)", $time, w32_y);

        w32_s = 2'b11; #5;
        $display("t=%0t | 32-bit Mux [S=11] - Out: 0x%h (Expect Fallback AAAAAAAA)", $time, w32_y);

        w5_d0 = 5'd10;
        w5_d1 = 5'd20;
        w5_d2 = 5'd30;

        w5_s = 2'b00; #5;
        $display("t=%0t |  5-bit Mux [S=00] - Out: %d (Expect 10)", $time, w5_y);

        w5_s = 2'b01; #5;
        $display("t=%0t |  5-bit Mux [S=01] - Out: %d (Expect 20)", $time, w5_y);

        w5_s = 2'b10; #5;
        $display("t=%0t |  5-bit Mux [S=10] - Out: %d (Expect 30)", $time, w5_y);

        $finish;
    end

endmodule