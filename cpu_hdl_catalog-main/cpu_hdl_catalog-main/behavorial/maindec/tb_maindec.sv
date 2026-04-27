/////////////////////////////////////////////////////////////////////////
// Christine Shammout, Shayna Levin
//
// Create Date: apr 27, 2026
// Module Name: tb_maindec
// Description: Testbench for Main Decoder including DSP ops
//
/////////////////////////////////////////////////////////////////////////

`ifndef TB_MAINDEC
`define TB_MAINDEC

`timescale 1ns/100ps
`include "maindec.sv"

module tb_maindec;

    // Inputs
    logic [5:0] op;

    // Outputs
    logic memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump;
    logic [1:0] aluop;

    // Instantiate the Unit Under Test (UUT)
    maindec uut (
        .op(op),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .branch(branch),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .aluop(aluop)
    );

    initial begin
        // Setup VCD file for GTKWave waveform viewing later
        $dumpfile("maindec.vcd");
        $dumpvars(0, tb_maindec);

        // 1. Test Standard MIPS R-Type
        op <= 6'b000000; #20;
        
        // 2. Test Standard MIPS LW (Load Word)
        op <= 6'b100011; #20;

        // 3. Test Custom DSP: MADD
        op <= 6'b111100; #20;

        // 4. Test Custom DSP: REPEAT
        op <= 6'b111101; #20;

        $finish;
    end

endmodule

`endif // TB_MAINDEC