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

//`include "cpu/cpu.sv"
`include "../imem/imem.sv"
`include "../dmem/dmem.sv"

module computer(
    input  logic        clk,
    input  logic        reset,
    
    // External tracking lines for debugging and verification
    output logic [31:0] pc_out,
    output logic [31:0] instr_out,
    output logic [31:0] aluout_out,
    output logic [31:0] writedata_out,
    output logic [31:0] readdata_out,
    output logic        memwrite_out,
    output logic        loop_active_out
);

    // Structural interconnect wires
    logic [31:0] pc, instr, aluout, writedata, readdata;
    logic        memwrite, loop_active;

    // Route internal signals out to the top-level ports for the testbench to see
    assign pc_out          = pc;
    assign instr_out       = instr;
    assign aluout_out      = aluout;
    assign writedata_out   = writedata;
    assign readdata_out    = readdata;
    assign memwrite_out    = memwrite;
    assign loop_active_out = loop_active;

    cpu pipeline_cpu (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .memwrite(memwrite),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata),
        .loop_active(loop_active)
    );

    imem instruction_ram (
        .addr(pc[7:2]), 
        .readdata(instr)
    );

    dmem data_ram (
        .clk(clk),
        .write_enable(memwrite),
        .addr(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );

endmodule

`endif // COMPUTER