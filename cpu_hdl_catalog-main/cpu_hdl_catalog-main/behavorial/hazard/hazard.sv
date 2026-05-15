`ifndef HAZARD
`define HAZARD

`timescale 1ns/100ps

module hazard (
    // Inputs from decode
    input  logic [4:0] rs_id,
    input  logic [4:0] rt_id,
    
    // Inputs from execute
    input  logic [4:0] rt_ex,
    input  logic       memtoreg_ex, 

    output logic       pc_en,         
    output logic       if_id_en,       
    output logic       id_ex_clear    
);

    always_comb begin
        // Default 
        pc_en        = 1'b1;
        if_id_en     = 1'b1;
        id_ex_clear  = 1'b0;

        if (memtoreg_ex && ((rt_ex == rs_id) || (rt_ex == rt_id))) begin
            pc_en        = 1'b0; 
            if_id_en     = 1'b0; 
            id_ex_clear  = 1'b1; 
        end
    end

endmodule

`endif // HAZARD