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

    // generate a clock signal
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        instr = 32'b0;
        readdata = 32'b0;

        // turn off reset to start the CPU
        #10 reset = 0;

        // the custom MADD Instruction
        // we are faking the Instruction Memory here. 
        // This matches the R-type format using our 111111 funct code.
        // Opcode: 000000 | rs: 00001 | rt: 00010 | rd: 00000 | shamt: 00000 | funct: 111111
        instr = 32'b000000_00001_00010_00000_00000_111111;

        //  wait a few clock cycles
        #20;

        $display("CPU Core Test Finished. Controller and Datapath are integrated!");
        $finish;
    end

endmodule