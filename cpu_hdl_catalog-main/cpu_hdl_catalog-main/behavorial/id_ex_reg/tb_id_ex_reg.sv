`timescale 1ns/100ps

module tb_id_ex_reg();

    parameter n = 32;

    // Clock and Control Signals
    logic          clk;
    logic          reset;
    logic          clear;

    // ID inputs
    logic          regwrite_id, memtoreg_id, memwrite_id, alusrc_id, regdst_id;
    logic [3:0]    alucontrol_id;
    logic [(n-1):0] rd1_id, rd2_id;
    logic [4:0]    rs_id, rt_id, rd_id;
    logic [(n-1):0] signimm_id;

    // EX outputs
    logic          regwrite_ex, memtoreg_ex, memwrite_ex, alusrc_ex, regdst_ex;
    logic [3:0]    alucontrol_ex;
    logic [(n-1):0] rd1_ex, rd2_ex;
    logic [4:0]    rs_ex, rt_ex, rd_ex;
    logic [(n-1):0] signimm_ex;

    // Instantiate UUT
    id_ex_reg #(n) dut (.*);

    // 10ns clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        clear = 0;
        
        // Prepare initial test values
        regwrite_id   = 1; memtoreg_id   = 0; memwrite_id   = 0;
        alusrc_id     = 0; regdst_id     = 1; alucontrol_id = 4'b0010;
        rd1_id        = 32'hAAAA_BBBB;   rd2_id        = 32'hCCCC_DDDD;
        rs_id         = 5'd2;            rt_id         = 5'd3;  rd_id = 5'd4;
        signimm_id    = 32'h0000_0000;

        // Check Reset State
        #12 reset = 0;
        $display("t=%0t | Reset released. EX_RegWrite: %b, EX_ALUOut Option: %b", $time, regwrite_ex, alucontrol_ex);

        // Clean pass-through behavior on clock edge
        #8;
        $display("t=%0t | Post-Clock Pass. EX_rd1: 0x%h, EX_rd2: 0x%h, Destination rd: %d", $time, rd1_ex, rd2_ex, rd_ex);
        
        // Set up new block
        regwrite_id   = 0; memwrite_id   = 1;
        rd1_id        = 32'h1111_2222;   rd2_id        = 32'h3333_4444;
        rs_id         = 5'd10;           rt_id         = 5'd11;

        // Asserting Clear
        #2;
        clear = 1; // Inject bubble
        
        #10;
        $display("t=%0t | Bubble Active (Should all clear to 0). EX_MemWrite: %b, EX_rd1: 0x%h", $time, memwrite_ex, rd1_ex);
        
        #10;
        clear = 0;
        #10;
        $finish;
    end

endmodule