//////////////////////////////////////////////////////////////////////////////////
// Christine, Shayna
// 
//     Create Date: may 12,2026
//     Module Name: computer
//     Description: 32-bit RISC
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef COMPUTER
`define COMPUTER

`timescale 1ns/100ps

`include "../cpu/cpu.sv"
`include "../imem/imem.sv"
`include "../dmem/dmem.sv"

module computer
    #(parameter n = 32)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
    input  logic           clk, reset, 
    output logic [(n-1):0] writedata, dataadr, 
    output logic           memwrite
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [(n-1):0] pc, instr, readdata;

//  The RISC CPU
    // used named mapping to ensure the 4-bit alucontrol logic inside works
    cpu mips(
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .memwrite(memwrite),
        .aluout(dataadr),
        .writedata(writedata),
        .readdata(readdata)
    );

    //  The instruction memory (ROM - holds your assembly code)
    // pc[7:2] handles word-alignment for a small 64-word memory
    imem imem(
        .a(pc[7:2]), 
        .rd(instr)
    );

    // The data memory (RAM - holds your data)
    dmem dmem(
        .clk(clk),
        .we(memwrite),
        .a(dataadr),
        .wd(writedata),
        .rd(readdata)
    );

endmodule

`endif // COMPUTER