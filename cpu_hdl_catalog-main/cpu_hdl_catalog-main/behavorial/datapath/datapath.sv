//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2023
// Engineer: Shayna and Christine
//     Create Date: 2023-02-07
//     Module Name: datapath
//     Description: 32-bit RISC-based CPU datapath (MIPS)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef DATAPATH
`define DATAPATH

`timescale 1ns/100ps

`include "if_id_reg.sv"
`include "id_ex_reg.sv"
`include "ex_mem_reg.sv"
`include "mem_wb_reg.sv"
`include "forwarding.sv"
`include "hazard.sv"
`include "mux3.sv"
`include "loop_ctrl.sv"

module datapath
    input  logic        clk, reset,
    input  logic        regwrite_id, regdst_id, alusrc_id,
    input  logic        branch_id, memwrite_id, memtoreg_id,
    input  logic [3:0]  alucontrol_id,
    input  logic        is_repeat_id,
    
    output logic [31:0] pc_if,
    input  logic [31:0] instr_if,
    output logic [31:0] aluout_mem,
    output logic [31:0] writedata_mem,
    input  logic [31:0] readdata_mem,
    
    output logic        loop_active_out
);
    logic [31:0] pc_next, pc_plus4_if;
    logic [31:0] pc_standard;
    
    assign pc_plus4_if = pc_if + 32'd4;
    
    assign pc_next = loop_active ? loop_target_pc : pc_standard; 
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)       pc_if <= 32'b0;
        else if (pc_en)  pc_if <= pc_next; 
    end

    logic [31:0] pc_plus4_id, instr_id;
    
    if_id_reg reg_if_id (
        .clk(clk), .reset(reset), .en(if_id_en), .clear(id_ex_clear),
        .pc_plus4_if(pc_plus4_if), .instr_if(instr_if),
        .pc_plus4_id(pc_plus4_id), .instr_id(instr_id)
    );

    logic [31:0] rd1_id, rd2_id;
    logic [31:0] signimm_id;
    
    logic [4:0]  rs_id, rt_id, rd_id;
    assign rs_id       = instr_id[25:21];
    assign rt_id       = instr_id[20:16];
    assign rd_id       = instr_id[15:11];
    assign signimm_id  = {{16{instr_id[15]}}, instr_id[15:0]}; // Sign extension

    logic [15:0] loop_size_id, loop_count_id;
    assign loop_size_id  = instr_id[15:0];  // N instructions to loop
    assign loop_count_id = instr_id[25:16]; // M iterations to run
    
    logic        regwrite_wb;
    logic [4:0]  wa3_wb;
    logic [31:0] result_wb;
    
    regfile rf (
        .clk(clk), .we3(regwrite_wb),
        .ra1(rs_id), .ra2(rt_id), .wa3(wa3_wb), .wd3(result_wb),
        .rd1(rd1_id), .rd2(rd2_id)
    );

    loop_ctrl zero_overhead_unit (
        .clk(clk), .reset(reset),
        .is_repeat_id(is_repeat_id), .loop_size_id(loop_size_id), .loop_count_id(loop_count_id), .pc_plus4_id(pc_plus4_id),
        .current_pc_if(pc_if),
        .loop_active(loop_active), .loop_target_pc(loop_target_pc)
    );

    logic regwrite_ex, memtoreg_ex, memwrite_ex, alusrc_ex, regdst_ex;
    logic [3:0] alucontrol_ex;
    logic [31:0] rd1_ex, rd2_ex;
    logic [4:0]  rs_ex, rt_ex, rd_ex;
    logic [31:0] signimm_ex;

    id_ex_reg reg_id_ex (
        .clk(clk), .reset(reset), .clear(id_ex_clear),
        .regwrite_id(regwrite_id), .memtoreg_id(memtoreg_id), .memwrite_id(memwrite_id),
        .alusrc_id(alusrc_id), .regdst_id(regdst_id), .alucontrol_id(alucontrol_id),
        .rd1_id(rd1_id), .rd2_id(rd2_id), .rs_id(rs_id), .rt_id(rt_id), .rd_id(rd_id), .signimm_id(signimm_id),
        
        .regwrite_ex(regwrite_ex), .memtoreg_ex(memtoreg_ex), .memwrite_ex(memwrite_ex),
        .alusrc_ex(alusrc_ex), .regdst_ex(regdst_ex), .alucontrol_ex(alucontrol_ex),
        .rd1_ex(rd1_ex), .rd2_ex(rd2_ex), .rs_ex(rs_ex), .rt_ex(rt_ex), .rd_ex(rd_ex), .signimm_ex(signimm_ex)
    );

    logic [31:0] src_a_muxout, src_b_forward_muxout, src_b_final;
    logic [31:0] aluout_ex;
    logic [4:0]  wa3_ex;
    logic        zero_ex;
    
    logic [31:0] aluout_mem_wire; // Forward tracking from ahead
    mux3 #(.WIDTH(32)) forward_mux_a (
        .d0(rd1_ex), .d1(result_wb), .d2(aluout_mem_wire), .s(forward_a), .y(src_a_muxout)
    );

    mux3 #(.WIDTH(32)) forward_mux_b (
        .d0(rd2_ex), .d1(result_wb), .d2(aluout_mem_wire), .s(forward_b), .y(src_b_forward_muxout)
    );

    assign src_b_final = alusrc_ex ? signimm_ex : src_b_forward_muxout;

    assign wa3_ex = regdst_ex ? rd_ex : rt_ex;

    alu core_alu (
        .clk(clk), .reset(reset),
        .src_a(src_a_muxout), .src_b(src_b_final), .alu_control(alucontrol_ex),
        .alu_result(aluout_ex), .zero(zero_ex)
    );

    logic regwrite_mem, memtoreg_mem, memwrite_mem;
    
    ex_mem_reg reg_ex_mem (
        .clk(clk), .reset(reset),
        .regwrite_ex(regwrite_ex), .memtoreg_ex(memtoreg_ex), .memwrite_ex(memwrite_ex),
        .aluout_ex(aluout_ex), .writedata_ex(src_b_forward_muxout), .wa3_ex(wa3_ex),
        
        .regwrite_mem(regwrite_mem), .memtoreg_mem(memtoreg_mem), .memwrite_mem(memwrite_mem),
        .aluout_mem(aluout_mem_wire), .writedata_mem(writedata_mem), .wa3_mem(wa3_mem)
    );
    
    assign aluout_mem = aluout_mem_wire; // Route to structural output boundary

    logic memtoreg_wb;
    logic [31:0] readdata_wb, aluout_wb;
    logic [4:0]  wa3_mem;

    mem_wb_reg reg_mem_wb (
        .clk(clk), .reset(reset),
        .regwrite_mem(regwrite_mem), .memtoreg_mem(memtoreg_mem),
        .readdata_mem(readdata_mem), .aluout_mem(aluout_mem_wire), .wa3_mem(wa3_mem),
        
        .regwrite_wb(regwrite_wb), .memtoreg_wb(memtoreg_wb),
        .readdata_wb(readdata_wb), .aluout_wb(aluout_wb), .wa3_wb(wa3_wb)
    );

    assign result_wb = memtoreg_wb ? readdata_wb : aluout_wb;

    forwarding forward_engine (
        .rs_ex(rs_ex), .rt_ex(rt_ex),
        .wa3_mem(wa3_mem), .regwrite_mem(regwrite_mem),
        .wa3_wb(wa3_wb), .regwrite_wb(regwrite_wb),
        .forward_a(forward_a), .forward_b(forward_b)
    );

    hazard hazard_engine (
        .rs_id(rs_id), .rt_id(rt_id),
        .rt_ex(rt_ex), .memtoreg_ex(memtoreg_ex),
        .pc_en(pc_en), .if_id_en(if_id_en), .id_ex_clear(id_ex_clear)
    );
    assign pc_standard = pc_plus4_if; 

endmodule

`endif // DATAPATH