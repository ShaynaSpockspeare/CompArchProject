/////////////////////////////////////////////////////////////////////////
// Christine, Shayna
//
// Create Date: apr 27, 2026
// Module Name: tb_aludec
// Description: Testbench for 4-bit ALU Decoder (MIPS + DSP)
//
// 
/////////////////////////////////////////////////////////////////////////
`ifndef TB_ALUDEC
`define TB_ALUDEC

`timescale 1ns/100ps
`include "aludec.sv"

module tb_aludec;

    // Inputs
    logic [5:0] funct;
    logic [1:0] aluop;

    // Outputs (with the upgrade to 4 bits)
    logic [3:0] alucontrol;

    // Instantiate the Unit Under Test (UUT)
    aludec uut (
        .funct(funct),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );

    initial begin
        // Setup VCD file for GTKWave waveform viewing later
        $dumpfile("aludec.vcd");
        $dumpvars(0, tb_aludec);

        // 1. Test Standard Memory (LW/SW), Should force ADD (0010)
        aluop <= 2'b00; funct <= 6'bxxxxxx; #20;

        // 2. Test Standard Branch (BEQ), Should force SUB (0110)
        aluop <= 2'b01; funct <= 6'bxxxxxx; #20;

        // 3. Test R-Type ADD,  Should look at funct and ADD (0010)
        aluop <= 2'b10; funct <= 6'b100000; #20;

        // 4. Test R-Type MULT, Should look at funct and MULT (0011)
        aluop <= 2'b10; funct <= 6'b011000; #20;

        // 5. Test CUSTOM DSP MADD, Should ignore funct and trigger MADD (1000)
        aluop <= 2'b11; funct <= 6'bxxxxxx; #20;

        $finish;
    end

endmodule

`endif // TB_ALUDEC