`timescale 1ns/100ps

module tb_forwarding();

    // Inputs
    logic [4:0] rs_ex;
    logic [4:0] rt_ex;
    logic [4:0] wa3_mem;
    logic       regwrite_mem;
    logic [4:0] wa3_wb;
    logic       regwrite_wb;

    // Outputs
    logic [1:0] forward_a;
    logic [1:0] forward_b;

    // Instantiate UUT
    forwarding dut (.*);

    initial begin
        rs_ex = 5'd2;
        rt_ex = 5'd3;
        wa3_mem = 5'd0; regwrite_mem = 0;
        wa3_wb  = 5'd0; regwrite_wb  = 0;

        // Baseline condition
        #10;
        $display("t=%0t | Base Path - ForwardA: %b (Expect 00), ForwardB: %b (Expect 00)", $time, forward_a, forward_b);

        // EX/MEM Data Hazard
        wa3_mem = 5'd2; regwrite_mem = 1;
        #10;
        $display("t=%0t | EX/MEM Hazard on rs - ForwardA: %b (Expect 10), ForwardB: %b (Expect 00)", $time, forward_a, forward_b);

        // MEM/WB Data Hazard
        wa3_mem = 5'd0; regwrite_mem = 0; 
        wa3_wb  = 5'd3; regwrite_wb  = 1;  
        #10;
        $display("t=%0t | MEM/WB Hazard on rt - ForwardA: %b (Expect 00), ForwardB: %b (Expect 01)", $time, forward_a, forward_b);

        // Both EX/MEM and MEM/WB hazards on the same source register
        rs_ex = 5'd4; rt_ex = 5'd5;
        wa3_mem = 5'd4; regwrite_mem = 1; 
        wa3_wb  = 5'd4; regwrite_wb  = 1; 
        #10;
        $display("t=%0t | Priority Overlap - ForwardA: %b (Expect 10), ForwardB: %b (Expect 00)", $time, forward_a, forward_b);

        // Edge Case
        rs_ex = 5'd0;
        wa3_mem = 5'd0; regwrite_mem = 1;
        #10;
        $display("t=%0t | Zero Register Check - ForwardA: %b (Expect 00)", $time, forward_a);

        $finish;
    end

endmodule