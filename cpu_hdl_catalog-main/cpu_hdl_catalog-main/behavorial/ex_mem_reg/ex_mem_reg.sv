`ifndef EX_MEM_REG
`define EX_MEM_REG

`timescale 1ns/100ps

module ex_mem_reg 
    #(parameter n = 32)(
    input  logic          clk,
    input  logic          reset,
    
    // Inputes!
    // Writeback Control
    input  logic          regwrite_ex,
    input  logic          memtoreg_ex,
    // Memory Control
    input  logic          memwrite_ex,
    
    // Datapath Results & Data
    input  logic [(n-1):0] aluout_ex,
    input  logic [(n-1):0] writedata_ex,  // Data from Register File 
    input  logic [4:0]     wa3_ex,        // Final destination register address from RegDst mux
    
    // Outputs!
    // Writeback Control
    output logic          regwrite_mem,
    output logic          memtoreg_mem,
    // Memory Control
    output logic          memwrite_mem,
    
    // Datapath Results & Data
    output logic [(n-1):0] aluout_mem,
    output logic [(n-1):0] writedata_mem,
    output logic [4:0]     wa3_mem        // Forwarded to forwarding unit to catch data hazards
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear all control and data lines on hardware reset
            regwrite_mem  <= 1'b0;
            memtoreg_mem  <= 1'b0;
            memwrite_mem  <= 1'b0;
            aluout_mem    <= {n{1'b0}};
            writedata_mem <= {n{1'b0}};
            wa3_mem       <= 5'b0;
        end else begin
            // Synchronous propagation to the Memory Stage
            regwrite_mem  <= regwrite_ex;
            memtoreg_mem  <= memtoreg_ex;
            memwrite_mem  <= memwrite_ex;
            aluout_mem    <= aluout_ex;
            writedata_mem <= writedata_ex;
            wa3_mem       <= wa3_ex;
        end
    end

endmodule

`endif // EX_MEM_REG