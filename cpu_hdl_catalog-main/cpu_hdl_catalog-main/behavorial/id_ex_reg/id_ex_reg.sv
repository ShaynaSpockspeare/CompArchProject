`ifndef ID_EX_REG
`define ID_EX_REG

`timescale 1ns/100ps

module id_ex_reg 
    #(parameter n = 32)(
    input  logic          clk,
    input  logic          reset,
    input  logic          clear,       // Active-high flush (inserts a pipeline bubble)
    
    // --- INPUTS FROM DECODE STAGE (ID) ---
    // Writeback Control
    input  logic          regwrite_id,
    input  logic          memtoreg_id,
    // Memory Control
    input  logic          memwrite_id,
    // Execute Control
    input  logic          alusrc_id,
    input  logic          regdst_id,
    input  logic [3:0]    alucontrol_id, // 4-bit for DSP/MADD support
    
    // Datapath Data
    input  logic [(n-1):0] rd1_id,
    input  logic [(n-1):0] rd2_id,
    input  logic [4:0]    rs_id,         // Needed by forwarding unit
    input  logic [4:0]    rt_id,         // Needed by forwarding/hazard unit
    input  logic [4:0]    rd_id,         // Needed for RegDst mux selection
    input  logic [(n-1):0] signimm_id,
    
    // --- OUTPUTS TO EXECUTE STAGE (EX) ---
    // Writeback Control
    output logic          regwrite_ex,
    output logic          memtoreg_ex,
    // Memory Control
    output logic          memwrite_ex,
    // Execute Control
    output logic          alusrc_ex,
    output logic          regdst_ex,
    output logic [3:0]    alucontrol_ex,
    
    // Datapath Data
    output logic [(n-1):0] rd1_ex,
    output logic [(n-1):0] rd2_ex,
    output logic [4:0]    rs_ex,
    output logic [4:0]    rt_ex,
    output logic [4:0]    rd_ex,
    output logic [(n-1):0] signimm_ex
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset || clear) begin
            // Synchronous clear
            regwrite_ex   <= 1'b0;
            memtoreg_ex   <= 1'b0;
            memwrite_ex   <= 1'b0;
            alusrc_ex     <= 1'b0;
            regdst_ex     <= 1'b0;
            alucontrol_ex <= 4'b0;
            rd1_ex        <= {n{1'b0}};
            rd2_ex        <= {n{1'b0}};
            rs_ex         <= 5'b0;
            rt_ex         <= 5'b0;
            rd_ex         <= 5'b0;
            signimm_ex    <= {n{1'b0}};
        end else begin
            // Stand cycle transmission
            regwrite_ex   <= regwrite_id;
            memtoreg_ex   <= memtoreg_id;
            memwrite_ex   <= memwrite_id;
            alusrc_ex     <= alusrc_id;
            regdst_ex     <= regdst_id;
            alucontrol_ex <= alucontrol_id;
            rd1_ex        <= rd1_id;
            rd2_ex        <= rd2_id;
            rs_ex         <= rs_id;
            rt_ex         <= rt_id;
            rd_ex         <= rd_id;
            signimm_ex    <= signimm_id;
        end
    end

endmodule

`endif // ID_EX_REG