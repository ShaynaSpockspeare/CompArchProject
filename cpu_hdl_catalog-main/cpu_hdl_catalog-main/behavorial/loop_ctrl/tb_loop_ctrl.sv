`timescale 1ns/100ps

module tb_loop_ctrl();

    logic        clk;
    logic        reset;
    logic        is_repeat_id;
    logic [15:0] loop_size_id;
    logic [15:0] loop_count_id;
    logic [31:0] pc_plus4_id;
    logic [31:0] current_pc_if;
    
    logic        loop_active;
    logic [31:0] loop_target_pc;

    // Instantiate UUT
    loop_ctrl dut (.*);

    // 10ns clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        is_repeat_id = 0;
        loop_size_id = 0;
        loop_count_id = 0;
        pc_plus4_id = 0;
        current_pc_if = 32'h0000_0000;

        // 1. Release reset
        #12 reset = 0;

        // 2. Simulate decoding a REPEAT 2, 3 instruction located at PC = 0x0000_0004
        // pc_plus4_id will be 0x0000_0008.
        // Loop block consists of instructions at 0x08 and 0x0C.
        // End boundary target is 0x08 + (2 * 4) = 0x0000_0010.
        is_repeat_id  = 1;
        loop_size_id  = 16'd2;
        loop_count_id = 16'd3;
        pc_plus4_id   = 32'h0000_0008;
        current_pc_if = 32'h0000_0008; // Fetch is processing the first instruction in the loop

        #10;
        is_repeat_id = 0; // Clear decoding token
        
        // --- RUNNING LOOP PASS 1 ---
        current_pc_if = 32'h0000_000C; #10; // Fetching second instruction in loop
        
        // Fetch hits the end boundary address (0x10)
        current_pc_if = 32'h0000_0010; 
        #1; // Allow combinational settlement
        $display("t=%0t | End Reached (Pass 1) - Active: %b (Exp 1), Target PC: 0x%h (Exp 00000008)", 
                 $time, loop_active, loop_target_pc);
        #9; 

        // --- RUNNING LOOP PASS 2 ---
        // Fetch logic snaps back to start address based on loop_active signal
        current_pc_if = 32'h0000_0008; #10;
        current_pc_if = 32'h0000_000C; #10;
        
        // Fetch hits end boundary address again
        current_pc_if = 32'h0000_0010;
        #1;
        $display("t=%0t | End Reached (Pass 2) - Active: %b (Exp 1), Target PC: 0x%h (Exp 00000008)", 
                 $time, loop_active, loop_target_pc);
        #9;

        // --- RUNNING LOOP PASS 3 (FINAL PASS) ---
        current_pc_if = 32'h0000_0008; #10;
        current_pc_if = 32'h0000_000C; #10;
        
        // Fetch hits end boundary address for the third time
        current_pc_if = 32'h0000_0010;
        #1;
        $display("t=%0t | End Reached (Pass 3) - Active: %b (Exp 1), Target PC: 0x%h (Exp 00000008)", 
                 $time, loop_active, loop_target_pc);
        #9;

        // --- LOOP COMPLETION EXIT ---
        // Because iteration bounds are depleted, loop_active must drop to 0, letting PC increment to 0x14
        current_pc_if = 32'h0000_0014;
        #1;
        $display("t=%0t | Loop Exited smoothly - Active: %b (Exp 0)", $time, loop_active);
        
        #9;
        $finish;
    end

endmodule