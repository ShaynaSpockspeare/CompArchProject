`timescale 1ns/100ps
`include "controller.sv"

module tb_controller;
    logic [5:0] op, funct;
    logic       zero;
    logic       memtoreg, memwrite, pcsrc, alusrc;
    logic       regdst, regwrite, jump;
    logic [2:0] alucontrol;

    controller uut (
        .op(op), .funct(funct), .zero(zero),
        .memtoreg(memtoreg), .memwrite(memwrite),
        .pcsrc(pcsrc), .alusrc(alusrc),
        .regdst(regdst), .regwrite(regwrite),
        .jump(jump), .alucontrol(alucontrol)
    );

    initial begin
        $dumpfile("controller.vcd");
        $dumpvars(0, tb_controller);

        $display("Testing Controller Logic...");
        op = 6'b000000; funct = 6'h20; zero = 0;
        #10;
        $display("R-Type ADD: RegWrite=%b, ALUControl=%b", regwrite, alucontrol);

        op = 6'h23; funct = 6'b0;
        #10;
        $display("LW: ALUSrc=%b, MemtoReg=%b, RegWrite=%b", alusrc, memtoreg, regwrite);

        op = 6'h04; zero = 1;
        #10;
        $display("BEQ Taken: PCSrc=%b (Should be 1)", pcsrc);

        op = 6'h04; zero = 0;
        #10;
        $display("BEQ Not Taken: PCSrc=%b (Should be 0)", pcsrc);

        op = 6'h02;
        #10;
        $display("Jump: Jump=%b", jump);

        #10 $finish;
    end
endmodule