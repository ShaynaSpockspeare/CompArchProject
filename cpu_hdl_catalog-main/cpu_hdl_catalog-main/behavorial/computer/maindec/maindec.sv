//////////////////////////////////////////////////////////////////////////////////
// Christine, Shayna
//
//     Create Date: apr 27,2026
//     Module Name: maindec
//     Description: 32-bit RISC-based CPU main decoder (MIPS)
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef MAINDEC
`define MAINDEC

`timescale 1ns/100ps

module maindec
    #(parameter n = 32)(
    input  logic [5:0] op,
    output logic       memtoreg, memwrite,
    output logic       branch, alusrc,
    output logic       regdst, regwrite,
    output logic       jump,
    output logic [1:0] aluop,
    output logic       is_repeat
);

    logic [9:0] controls; // 10-bit control vector

    // controls has 10 logical signals
    assign {regwrite, regdst, alusrc, branch, memwrite,
            memtoreg, jump, aluop} = controls;

    always @* begin
        case(op)
            6'b000000: controls <= 10'b110000010; // RTYPE
            6'b100011: controls <= 10'b101001000; // LW
            6'b101011: controls <= 10'b001010000; // SW
            6'b000100: controls <= 10'b000100001; // BEQ
            6'b001000: controls <= 10'b101000000; // ADDI
            6'b000010: controls <= 10'b000000100; // J

            // more Instructions for DSP 
            6'b111100: controls = 10'b000000011; // MADD (Multiply-Accumulate)
            6'b111101: controls = 10'b000000000; // REPEAT (Zero-Overhead Loop)


            default:   controls <= 10'bxxxxxxxxxx; // illegal operation
        endcase
    end

endmodule

`endif // MAINDEC
