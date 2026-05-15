`timescale 1ns/100ps

module tb_hazard();

    // Inputs
    logic [4:0] rs_id;
    logic [4:0] rt_id;
    logic [4:0] rt_ex;
    logic       memtoreg_ex;

    // Outputs
    logic       pc_en;
    logic       if_id_en;
    logic       id_ex_clear;

    // Instantiate UUT
    hazard dut (.*);

    initial begin

        rs_id = 5'd2;
        rt_id = 5'd3;
        rt_ex = 5'd4;
        memtoreg_ex = 0;
        
        #10;
        $display("t=%0t | Normal Run - PC_En: %b (Exp 1), IF/ID_En: %b (Exp 1), ID/EX_Clr: %b (Exp 0)", 
                 $time, pc_en, if_id_en, id_ex_clear);

        // Incomplete Hazard :(
        memtoreg_ex = 1; 
        #10;
        $display("t=%0t | Safe Load  - PC_En: %b (Exp 1), IF/ID_En: %b (Exp 1), ID/EX_Clr: %b (Exp 0)", 
                 $time, pc_en, if_id_en, id_ex_clear);

        // Load-Use Hazard Encountered!
        rs_id = 5'd4;
        #10;
        $display("t=%0t | COLLISION - PC_En: %b (Exp 0), IF/ID_En: %b (Exp 0), ID/EX_Clr: %b (Exp 1)", 
                 $time, pc_en, if_id_en, id_ex_clear);

        // Recovery state
        memtoreg_ex = 0;
        #10;
        $display("t=%0t | Recovery  - PC_En: %b (Exp 1), IF/ID_En: %b (Exp 1), ID/EX_Clr: %b (Exp 0)", 
                 $time, pc_en, if_id_en, id_ex_clear);

        $finish;
    end

endmodule