`timescale 1ns/100ps

module tb_if_id_reg();

    parameter n = 32;

    // Tb signals
    logic          clk;
    logic          reset;
    logic          en;
    logic          clear;
    logic [(n-1):0] pc_plus4_if;
    logic [(n-1):0] instr_if;
    logic [(n-1):0] pc_plus4_id;
    logic [(n-1):0] instr_id;

    if_id_reg #(n) dut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .clear(clear),
        .pc_plus4_if(pc_plus4_if),
        .instr_if(instr_if),
        .pc_plus4_id(pc_plus4_id),
        .instr_id(instr_id)
    );

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize everything
        clk = 0;
        reset = 1;
        en = 1;
        clear = 0;
        pc_plus4_if = 32'h0000_0004;
        instr_if    = 32'h2002_000a; // addi $v0, $zero, 10

        // Check Reset State
        #12 reset = 0;
        $display("t=%0t | Reset released. Out PC: 0x%h, Out Instr: 0x%h", $time, pc_plus4_id, instr_id);
        
        // Check Normal Propagation 
        #8; // Right before next posedge
        $display("t=%0t | Normal Step. Out PC: 0x%h, Out Instr: 0x%h", $time, pc_plus4_id, instr_id);
        
        // Setup new values for next cycle
        pc_plus4_if = 32'h0000_0008;
        instr_if    = 32'h2003_000f; // addi $v1, $zero, 15
        
        //Check Stall Behavior 
        #10;
        en = 0; 
        pc_plus4_if = 32'h0000_000c; // These inputs should be completely ignored
        instr_if    = 32'h0043_1022; 
        
        #10;
        $display("t=%0t | Stalled Step (Should match previous output). Out PC: 0x%h, Out Instr: 0x%h", $time, pc_plus4_id, instr_id);
        
        // Check Flush Behavior
        en = 1;
        clear = 1;
        
        #10;
        $display("t=%0t | Flushed Step (Should clear to 0). Out PC: 0x%h, Out Instr: 0x%h", $time, pc_plus4_id, instr_id);
        
        #10;
        clear = 0;
        #10;
        $finish;
    end

endmodule