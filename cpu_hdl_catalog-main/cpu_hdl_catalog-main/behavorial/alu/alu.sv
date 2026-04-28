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

module alu
    #(parameter n = 32)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
    input  logic        clk,
    input  logic [(n-1):0] a, b,
    input  logic [3:0]  alucontrol, // upgraded this line 
    output logic [(n-1):0] result,
    output logic        zero
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [(n-1):0] condinvb, sum;
    logic [(2*n-1):0] HiLo;

    assign zero = (result == {n{1'b0}}); // zero result control signal
    assign condinvb = alucontrol[2] ? ~b : b;
    assign sumSlt = a + condinvb + alucontrol[2]; // (a-b using 2s complement) test if a == b, if b<a, then sumSlt will have neg bit[31]

    // initialize the internal HiLo register used in multiplying two 32-bit numbers = a 64-bit number.
    initial
        begin
            HiLo = 64'b0;
        end

    always @(a,b,alucontrol) begin
        case (alucontrol)
            4'b0000: result = a & b;             // and
            4'b0001: result = a | b;             // or
            4'b0010: result = a + b;             // add
            4'b0110: result = sumSlt;            // sub
            4'b0100: result = HiLo[(n-1):0];     // MFLO lower 32 bits
            4'b0101: result = HiLo[(2*n-1):n];   // MFHI higher 32 bits
            4'b0111: begin                       // slt
				if (a[31] != b[31]) begin
					if (a[31] > b[31])
						result = 1;
					else
						result = 0;
                 end else begin
                 if (a < b) result = 1; 
				else result = 0;
					if (a < b)
						result = 1;
					else
						result = 0;
            end
        end 
        default: result = 32'b0; // Safety default
    endcase

    //Multiply and DSP results are only stored at clock falling edge.
    always @(negedge clk) begin
        case (alucontrol)
            4'b0011: HiLo = a * b; // mult

            4'b1000: HiLo = HiLo + (a * b); // MADD (custom to DSP)
        endcase				
    end
 // removed the division logic to accomodate DSP (MIPS DSPs 
 // rarely use hardware division)
 
 endmodule
 'endif // ALU