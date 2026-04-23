`timescale 1ns/100ps

module tb_regfile();
    // Parameters
    parameter n = 32;
    parameter r = 5;

    // Signals
    logic clk;
    logic we3;
    logic [r-1:0] ra1, ra2, wa3;
    logic [n-1:0] wd3;
    logic [n-1:0] rd1, rd2;

    // Instantiate the Unit Under Test (UUT)
    regfile #(n, r) uut (
        .clk(clk), .we3(we3), 
        .ra1(ra1), .ra2(ra2), .wa3(wa3), 
        .wd3(wd3), .rd1(rd1), .rd2(rd2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0; we3 = 0; 
        ra1 = 0; ra2 = 0; wa3 = 0; wd3 = 0;

        // Setup Waveform Dumping (Required for GTKWave/Makefile)
        $dumpfile("regfile.vcd");
        $dumpvars(0, tb_regfile);

        // TEST 1: Write to Register 5
        #10;
        wa3 = 5; wd3 = 32'hDEADBEEF; we3 = 1;
        #10;
        we3 = 0;

        // TEST 2: Read from Register 5
        #10;
        ra1 = 5; // rd1 should become DEADBEEF

        // TEST 3: Try to write to Register 0 (Should remain 0)
        #10;
        wa3 = 0; wd3 = 32'hFFFFFFFF; we3 = 1;
        #10;
        we3 = 0;
        ra2 = 0; // rd2 should stay 0

        #20;
        $display("Simulation Finished");
        $finish;
    end
endmodule