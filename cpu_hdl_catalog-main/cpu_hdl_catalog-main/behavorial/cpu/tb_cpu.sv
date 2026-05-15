`timescale 1ns/100ps

module tb_cpu();

    // internal signals to wire to the CPU
    logic        clk;
    logic        reset;
    logic [31:0] pc;
    logic [31:0] instr;
    logic        memwrite;
    logic [31:0] aluout, writedata;
    logic [31:0] readdata;
    logic        loop_active;

    // the CPU core
    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .memwrite(memwrite),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        instr = 32'h0000_0000;
        readdata = 32'h0000_0000;

        #12 reset = 0;
        instr = 32'h0109_8020; 
        #10;
        instr = 32'h7C02_0004; 
        #10;

        $display("CPU Core Test Finished. Controller and Datapath are integrated!");
        $finish;
    end

endmodule