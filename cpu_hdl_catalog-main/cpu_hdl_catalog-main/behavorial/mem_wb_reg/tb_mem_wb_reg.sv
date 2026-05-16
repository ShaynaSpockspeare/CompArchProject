`timescale 1ns/100ps

module tb_mem_wb_reg();

    parameter n = 32;

    // Clock and Reset
    logic          clk;
    logic          reset;

    // MEM Inputs
    logic          regwrite_mem, memtoreg_mem;
    logic [(n-1):0] readdata_mem, aluout_mem;
    logic [4:0]     wa3_mem;

    // WB Outputs
    logic          regwrite_wb, memtoreg_wb;
    logic [(n-1):0] readdata_wb, aluout_wb;
    logic [4:0]     wa3_wb;

    // Instantiate UUT
    mem_wb_reg #(n) dut (.*);

    // 10ns Clock Generator
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
       
        // Data read from RAM is 0xABCDEFFF, target destination is $s0 (Register 16)
        regwrite_mem = 1; 
        memtoreg_mem = 1; 
        readdata_mem = 32'hABCD_EFFF;
        aluout_mem   = 32'h0000_0028; 
        wa3_mem      = 5'd16;

        // Check hardware Reset clear behavior
        #12 reset = 0;
        $display("t=%0t | Reset released. WB_RegWrite: %b, WB_ReadData: 0x%h", $time, regwrite_wb, readdata_wb);

        // Capture the Load Word transition on the clock edge
        #8;
        $display("t=%0t | Post-Clock Capture (lw). WB_MemtoReg: %b, WB_ReadData: 0x%h, Target wa3: %d", 
                 $time, memtoreg_wb, readdata_wb, wa3_wb);

        // Calculated result is 0x000000AA, target destination is $t1 (Register 9)
        regwrite_mem = 1;
        memtoreg_mem = 0; // Choose the ALU calculation path out of the final mux
        readdata_mem = 32'h0000_0000;
        aluout_mem   = 32'h0000_00AA;
        wa3_mem      = 5'd9;

        #10;
        $display("t=%0t | Next Cycle Capture (add). WB_MemtoReg: %b, WB_ALUOut: 0x%h, Target wa3: %d", 
                 $time, memtoreg_wb, aluout_wb, wa3_wb);

        #10;
        $finish;
    end

endmodule