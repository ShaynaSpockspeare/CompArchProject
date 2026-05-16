`timescale 1ns/100ps

module tb_computer();

    logic        clk;
    logic        reset;
    
    logic [31:0] pc_out;
    logic [31:0] instr_out;
    logic [31:0] aluout_out;
    logic [31:0] writedata_out;
    logic [31:0] readdata_out;
    logic        memwrite_out;
    logic        loop_active;

    // Instantiate System Top-Level
    computer tut (.*);

    // Generate 10ns system clock
    always #5 clk = ~clk;

    initial begin
        // Initialize memory arrays 
        $readmemh("memfile.dat", tut.instruction_ram.RAM);
        
        clk = 0;
        reset = 1;
        #12 reset = 0; 
    end

    always @(negedge clk) begin
        if (memwrite) begin
            $display("t=%0t | [MEMORY WRITE] - Address: 0x%h, Data Written: 0x%h", $time, aluout, writedata);
            
            if (aluout === 32'h0000_00FC) begin
                $display("======================================================");
                $display("  SIMULATION COMPLETE: Success Target Captured! Yay!  ");
                $display("======================================================");
                $finish;
            end
        end
    end

    initial begin
        #5000;
        $display("ERROR: Simulation timed out before reaching completion target.");
        $finish;
    end

endmodule