`ifndef IF_ID_REG
`define IF_ID_REG

`timescale 1ns/100ps

module if_id_reg 
    #(parameter n = 32)(
    input  logic          clk,
    input  logic          reset,
    input  logic          en,      // Active-low stall signal (0 = freeze, 1 = pass)
    input  logic          clear,   // Active-high flush signal (1 = clear to NOP)
    input  logic [(n-1):0] pc_plus4_if,
    input  logic [(n-1):0] instr_if,
    output logic [(n-1):0] pc_plus4_id,
    output logic [(n-1):0] instr_id
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_plus4_id <= {n{1'b0}};
            instr_id    <= {n{1'b0}}; // Resets to a NOP (sll $0, $0, 0)
        end else if (clear) begin
            pc_plus4_id <= {n{1'b0}};
            instr_id    <= {n{1'b0}}; // Flush converts current instruction to NOP
        end else if (en) begin
            pc_plus4_id <= pc_plus4_if;
            instr_id    <= instr_if;
        end
        // If en is 0 and clear is 0, the internal registers maintain their state (Stall)
    end

endmodule

`endif // IF_ID_REG