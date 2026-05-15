/////////////////////////////////////////////////////////////////////////
// Christine, Shayna
// Create Date: Ap 28, 2026
// Module Name: tb_alu
// Description: Testbench for 32-bit ALU with custom DSP MADD
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module tb_alu();

    logic        clk;
    logic        reset;
    logic [31:0] src_a;
    logic [31:0] src_b;
    logic [3:0]  alu_control;
    
    logic [31:0] alu_result;
    logic        zero;

    // Instantiate UUT
    alu dut (.*);

    // 10ns clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        src_a = 0;
        src_b = 0;
        alu_control = 4'b0000;

        // Check reset state
        #12 reset = 0;

        src_a = 32'd15;
        src_b = 32'd25;
        alu_control = 4'b0010; // ADD
        #2;
        $display("t=%0t | Combinational ADD - Result: %d (Expect 40), Zero: %b", $time, alu_result, zero);

        #8; // Sync back close to clock edge
        src_a = 32'd4;
        src_b = 32'd5;
        alu_control = 4'b1000; // MADD
        
        #10; // Wait for positive edge write
        src_a = 32'd3;
        src_b = 32'd10;
        
        #10; // Wait for next positive edge write
        alu_control = 4'b0010; // Switch to normal ADD
        src_a = 32'd0;
        src_b = 32'd0;
        
        // MADD control check
        alu_control = 4'b1000;
        #1;
        $display("t=%0t | Cumulative DSP MADD - Result: %d (Expect 50)", $time, alu_result);

        #9;
        $finish;
    end

endmodule