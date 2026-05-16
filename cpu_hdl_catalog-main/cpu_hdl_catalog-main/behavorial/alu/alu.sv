//////////////////////////////////////////////////////////////////////////////////
// Christine, Shayna
// 
//     Create Date: apr 28, 2026
//     Module Name: alu
//     Description: 32-bit RISC-based CPU alu (MIPS)
//
// see https://github.com/Caskman/MIPS-Processor-in-Verilog/blob/master/ALU32Bit.v
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALU
`define ALU

`timescale 1ns/100ps

module alu(

    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] src_a,         // Operand A (Forwarded rs value)
    input  logic [31:0] src_b,         // Operand B (Forwarded rt or SignImm value)
    input  logic [3:0]  alu_control,   // Control token opcode
    
    output logic [31:0] alu_result,
    output logic        zero
);
    logic [31:0] hi_reg;
    logic [31:0] lo_reg;
    logic [64:0] product;
    logic [63:0] current_accumulator;
    logic [63:0] next_accumulator;

    // Combinational Math Blocks
    always_comb begin
        // Default assignments to prevent latch generation
        product           = 65'b0;
        current_accumulator = {hi_reg, lo_reg};
        next_accumulator    = current_accumulator;
        
        case (alu_control)
            4'b0000: alu_result = src_a & src_b; // AND
            4'b0001: alu_result = src_a | src_b; // OR
            4'b0010: alu_result = src_a + src_b; // ADD
            4'b0110: alu_result = src_a - src_b; // SUBTRACT
            4'b0111: alu_result = (src_a < src_b) ? 32'b1 : 32'b0; // SLT
            4'b1100: alu_result = ~(src_a | src_b); // NOR

            4'b1000: begin // MADD 
                // Signed multiply of the two 32-bit inputs
                product = $signed(src_a) * $signed(src_b);
                // Accumulate with the existing 64-bit state
                next_accumulator = current_accumulator + product[63:0];
                // Route lower 32-bits to output for convenience if needed
                alu_result = next_accumulator[31:0]; 
            end
            
            default: alu_result = 32'b0;
        endcase
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            hi_reg <= 32'b0;
            lo_reg <= 32'b0;
        end else if (alu_control == 4'b1000) begin
            hi_reg <= next_accumulator[63:32];
            lo_reg <= next_accumulator[31:0];
        end
    end

    assign zero = (alu_result == 32'b0);

endmodule

`endif // ALU