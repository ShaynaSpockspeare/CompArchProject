`timescale 1ns/100ps

module tb_ex_mem_reg();

    parameter n = 32;

    // Clock and Reset
    logic          clk;
    logic          reset;

    // EX Inputs
    logic          regwrite_ex, memtoreg_ex, memwrite_ex;
    logic [(n-1):0] aluout_ex, writedata_ex;
    logic [4:0]     wa3_ex;

    // MEM Outputs
    logic          regwrite_mem, memtoreg_mem, memwrite_mem;
    logic [(n-1):0] aluout_mem, writedata_mem;
    logic [4:0]     wa3_mem;

    // Instantiate UUT
    ex_mem_reg #(n) dut (.*);

    // 10ns Clock Generator
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        
        // Setup mock inputs for a store instruction: sw $t0, 44($s3)
        // Let's pretend $t0 holds 0xDEADBEEF and the target memory address is 0x00000054
        regwrite_ex  = 0; 
        memtoreg_ex  = 0; 
        memwrite_ex  = 1; // Needs to write to RAM
        aluout_ex    = 32'h0000_0054;
        writedata_ex = 32'hDEAD_BEEF;
        wa3_ex       = 5'd0; // sw doesn't write back to the register file

        // Release Reset and check clean clear state
        #12 reset = 0;
        $display("t=%0t | Reset released. MEM_MemWrite: %b, MEM_ALUOut: 0x%h", $time, memwrite_mem, aluout_mem);

        // Observe propagation after the first clock edge
        #8;
        $display("t=%0t | Post-Clock Capture. MEM_MemWrite: %b, MEM_ALUOut: 0x%h, MEM_WriteData: 0x%h", 
                 $time, memwrite_mem, aluout_mem, writedata_mem);

        // Setup inputs for an ALU operation instruction that follows right behind it
        regwrite_ex  = 1;
        memtoreg_ex  = 0;
        memwrite_ex  = 0;
        aluout_ex    = 32'h0000_0096; // Resulting calculation value
        writedata_ex = 32'h0000_0000;
        wa3_ex       = 5'd4;          // Writing to destination register $a0

        #10;
        $display("t=%0t | Next Cycle Capture. MEM_RegWrite: %b, MEM_ALUOut: 0x%h, Target Register wa3: %d", 
                 $time, regwrite_mem, aluout_mem, wa3_mem);

        #10;
        $finish;
    end

endmodule