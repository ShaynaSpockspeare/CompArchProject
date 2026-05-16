//////////////////////////////////////////////////////////////////////////////////
// Christine, Shayna
// 
//     Create Date: may 9, 2026
//     Module Name: cpu
//     Description: 32-bit RISC-based CPU (MIPS)
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef CPU
`define CPU

`timescale 1ns/100ps

//`include "controller/controller.sv"
//`include "datapath/datapath.sv"

module cpu
    #(parameter n = 32)(
   
    input  logic           clk, reset,
   output logic [31:0] pc,
    input  logic [31:0] instr,

    output logic        memwrite,
    output logic [31:0] aluout,
    output logic [31:0] writedata,
    input  logic [31:0] readdata,
    
    output logic        loop_active
);
    logic        regwrite, regdst, alusrc, branch, memtoreg, jump;
    logic [3:0]  alucontrol;
    logic        is_repeat;

    // the control unit
    controller c (
        .op(instr[31:26]),
        .funct(instr[5:0]),
        .zero(zero),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .is_repeat(is_repeat)
    );
 
    // datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .regwrite_id(regwrite),
        .regdst_id(regdst),
        .alusrc_id(alusrc),
        .branch_id(branch),
        .memwrite_id(memwrite),
        .memtoreg_id(memtoreg),
        .alucontrol_id(alucontrol),
        .is_repeat_id(is_repeat),
        .pc_if(pc),
        .instr_if(instr),
        .aluout_mem(aluout),
        .writedata_mem(writedata),
        .readdata_mem(readdata),
        .loop_active_out(loop_active)
    );

endmodule

`endif // CPU