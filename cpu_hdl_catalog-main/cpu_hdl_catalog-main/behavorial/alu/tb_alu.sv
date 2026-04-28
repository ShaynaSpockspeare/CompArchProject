/////////////////////////////////////////////////////////////////////////
// Christine, Shayna
// Create Date: Ap 28, 2026
// Module Name: tb_alu
// Description: Testbench for 32-bit ALU with custom DSP MADD
/////////////////////////////////////////////////////////////////////////
`ifndef TB_ALU
`define TB_ALU

`timescale 1ns/100ps
`include "alu.sv"

module tb_alu;

    // Inputs
    logic clk;
    logic [31:0] a, b;
    logic [3:0] alucontrol;

    // Outputs
    logic [31:0] result;
    logic zero;

    // Instantiate the Unit Under Test (UUT)
    // We pass the parameter n = 32 for a 32-bit ALU
    alu #(32) uut (
        .clk(clk),
        .a(a),
        .b(b),
        .alucontrol(alucontrol),
        .result(result),
        .zero(zero)
    );

    // ---------------------------------------------------------
    // CLOCK GENERATOR: Flips the clock signal every 5 nanoseconds
    // ---------------------------------------------------------
    always #5 clk = ~clk;

    initial begin
        // Setup VCD file for GTKWave waveform viewing later
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu);

        // Initialize Inputs
        clk = 0;
        a = 32'd0; 
        b = 32'd0; 
        alucontrol = 4'b0000;

        // 1. Test ADD (4'b0010): 10 + 15 = 25
        #10 a = 32'd10; b = 32'd15; alucontrol = 4'b0010;

        // 2. Test SUB (4'b0110): 20 - 5 = 15
        #10 a = 32'd20; b = 32'd5; alucontrol = 4'b0110;

        // 3. Test Standard MULT (4'b0011): 4 * 5 = 20
        // (This saves the 20 into the HiLo register on the clock drop)
        #10 a = 32'd4; b = 32'd5; alucontrol = 4'b0011;
        #10; // Wait for the clock cycle to finish

        // 4. Test MFLO (4'b0100): Should output the 20 we just calculated
        #10 alucontrol = 4'b0100; 

        // 5. Test CUSTOM DSP MADD (4'b1000): 3 * 6 = 18. 
        // It should add 18 to the existing 20 in the HiLo register!
        #10 a = 32'd3; b = 32'd6; alucontrol = 4'b1000;
        #10; // Wait for the clock cycle to finish

        // 6. Test MFLO again (4'b0100): Should output 38!
        #10 alucontrol = 4'b0100;

        #20 $finish;
    end

endmodule

`endif // TB_ALU