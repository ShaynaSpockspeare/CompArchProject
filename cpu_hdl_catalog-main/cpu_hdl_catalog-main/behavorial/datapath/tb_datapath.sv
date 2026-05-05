`timescale 1ns/100ps
`include "datapath.sv"

module tb_datapath;
    parameter n = 32;

    // Inputs
    logic clk, reset;
    logic memtoreg, pcsrc, alusrc, regdst, regwrite, jump;
    logic [3:0] alucontrol;
    logic [n-1:0] instr;
    logic [n-1:0] readdata;

    // Outputs
    logic zero;
    logic [n-1:0] pc, aluout, writedata;

    // Instantiate UUT
    datapath #(n) uut (.*); // Use .* to connect matching names

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars(0, tb_datapath);

        // Initialize
        clk = 0; reset = 1;
        memtoreg = 0; pcsrc = 0; alusrc = 0; regdst = 0;
        regwrite = 0; jump = 0; alucontrol = 3'b010; // ADD
        instr = 0; readdata = 0;

        #12 reset = 0;

        instr = 32'h02324020;
        regwrite = 1; regdst = 1; alusrc = 0; 
        #10;
      
        jump = 1;
        instr = 32'h08000004; 
        #10;
        jump = 0;

        #20;
        $display("Datapath test finished.");
        $finish;
    end
endmodule