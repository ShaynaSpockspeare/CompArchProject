//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2026
// Engineer: Shayna Levin 
// 
//     Create Date: 2023-02-07
//     Module Name: regfile
//     Description: 32-bit RISC register file
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef REGFILE
`define REGFILE

`timescale 1ns/100ps

module regfile
    // n=bit length of register; r=bit length of addr of registers
    #(parameter n = 32, parameter r = 5)(
    input  logic        clk, 
    input  logic        we3, 
    input  logic [4:0]  ra1, ra2, wa3, 
    input  logic [31:0] wd3, 
    output logic [31:0] rd1, rd2
    );

    logic [31:0] rf[31:0];

    always_ff @(negedge clk) begin
        if (we3) begin
            rf[wa3] <= wd3;
        end
    end

    always_comb begin
        if (ra1 == 5'b0)          rd1 = 32'b0; // MIPS register 0 is always hardwired to 0
        else if (ra1 == wa3 && we3) rd1 = wd3;   // Internal forwarding bypass
        else                      rd1 = rf[ra1];
        
        if (ra2 == 5'b0)          rd2 = 32'b0; // MIPS register 0 is always hardwired to 0
        else if (ra2 == wa3 && we3) rd2 = wd3;   // Internal forwarding bypass
        else                      rd2 = rf[ra2];
    end
endmodule

`endif // REGFILE