//////////////////////////////////////////////////////////////////////////////////
// Christine, Shayna 
// 
//     Create Date: apr 27,2026
//     Module Name: aludec
//     Description: 32-bit RISC ALU decoder
//
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALUDEC
`define ALUDEC

`timescale 1ns/100ps

module aludec (
    input  logic [5:0] funct,
    input  logic [1:0] aluop,
    output logic [3:0] alucontrol 
);

    always_comb begin
        case (aluop)
            2'b00: alucontrol = 4'b0010; 
            2'b01: alucontrol = 4'b0110; 
            
            2'b10: begin                
                case (funct)
                    6'b100000: alucontrol = 4'b0010; // ADD
                    6'b100010: alucontrol = 4'b0110; // SUBTRACT
                    6'b100100: alucontrol = 4'b0000; // AND
                    6'b100101: alucontrol = 4'b0001; // OR
                    6'b101010: alucontrol = 4'b0111; // SLT
                    6'b111111: alucontrol = 4'b1000; // Triggers 64-bit Multiply-Accumulate block
                    
                    default:   alucontrol = 4'b0000;
                endcase
            end
            
            default: alucontrol = 4'b0000;
        endcase
    end

endmodule

`endif // ALUDEC
`endif // ALUDEC