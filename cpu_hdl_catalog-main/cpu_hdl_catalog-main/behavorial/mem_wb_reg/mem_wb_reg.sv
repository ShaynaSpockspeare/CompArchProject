`ifndef MEM_WB_REG
`define MEM_WB_REG

`timescale 1ns/100ps

module mem_wb_reg 
    #(parameter n = 32)(
    input  logic          clk,
    input  logic          reset,
    
    // --- INPUTS FROM MEMORY STAGE (MEM) ---
    // Writeback Control
    input  logic          regwrite_mem,
    input  logic          memtoreg_mem,
    
    // Datapath Data & Results
    input  logic [(n-1):0] readdata_mem,  // Data pulled from dmem RAM
    input  logic [(n-1):0] aluout_mem,    // Direct calculation path bypass
    input  logic [4:0]     wa3_mem,       // Destination register address
    
    // --- OUTPUTS TO WRITEBACK STAGE (WB) ---
    // Writeback Control
    output logic          regwrite_wb,
    output logic          memtoreg_wb,
    
    // Datapath Data & Results
    output logic [(n-1):0] readdata_wb,
    output logic [(n-1):0] aluout_wb,
    output logic [4:0]     wa3_wb         // Forwarded back to the forwarding unit
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            regwrite_wb  <= 1'b0;
            memtoreg_wb  <= 1'b0;
            readdata_wb  <= {n{1'b0}};
            aluout_wb    <= {n{1'b0}};
            wa3_wb       <= 5'b0;
        end else begin
            // Synchronous handoff to the final Writeback phase
            regwrite_wb  <= regwrite_mem;
            memtoreg_wb  <= memtoreg_mem;
            readdata_wb  <= readdata_mem;
            aluout_wb    <= aluout_mem;
            wa3_wb       <= wa3_mem;
        end
    end

endmodule

`endif // MEM_WB_REG