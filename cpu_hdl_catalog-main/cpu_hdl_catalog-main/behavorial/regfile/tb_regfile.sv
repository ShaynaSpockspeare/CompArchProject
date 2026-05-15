`timescale 1ns/100ps

module tb_regfile();

    logic        clk;
    logic        we3;
    logic [4:0]  ra1, ra2, wa3;
    logic [31:0] wd3;
    logic [31:0] rd1, rd2;

    // Instantiate UUT
    regfile dut (.*);

    // 10ns Clock Generator
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we3 = 0;
        ra1 = 0; ra2 = 0; wa3 = 0; wd3 = 0;

        #12; // Wait until after a clock edge
        wa3 = 5'd0; wd3 = 32'hFFFF_FFFF; we3 = 1; // Try to write to Reg 0
        #10; // Wait for negedge write to pass
        we3 = 0; ra1 = 5'd0;
        #1;
        $display("t=%0t | Register 0 Check - Data: 0x%h (Expect 00000000)", $time, rd1);

        wa3 = 5'd4; wd3 = 32'hAAAA_BBBB; we3 = 1;
        #10; // Allow falling-edge write commitment
        we3 = 0; ra1 = 5'd4;
        #1;
        $display("t=%0t | Standard Read  - Reg4: 0x%h (Expect AAAABBBB)", $time, rd1);

        ra2 = 5'd4; wa3 = 5'd4; wd3 = 32'hCCCC_DDDD; we3 = 1;
        #1; // Check immediately BEFORE the clock edge 
        $display("t=%0t | Bypass Active  - Reg4 Read: 0x%h (Expect CCCCDDDD)", $time, rd2);

        #9;
        $finish;
    end

endmodule