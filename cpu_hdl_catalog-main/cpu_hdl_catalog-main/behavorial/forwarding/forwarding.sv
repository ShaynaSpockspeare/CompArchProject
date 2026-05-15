`ifndef FORWARDING
`define FORWARDING

`timescale 1ns/100ps

module forwarding (
    input  logic [4:0] rs_ex,
    input  logic [4:0] rt_ex,

    input  logic [4:0] wa3_mem,
    input  logic       regwrite_mem,

    input  logic [4:0] wa3_wb,
    input  logic       regwrite_wb,

    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    always_comb begin
        // EX/MEM stage
        if (regwrite_mem && (wa3_mem != 5'b0) && (wa3_mem == rs_ex)) begin
            forward_a = 2'b10;
        end
        // MEM/WB stage 
        else if (regwrite_wb && (wa3_wb != 5'b0) && (wa3_wb == rs_ex)) begin
            forward_a = 2'b01;
        end
        // No hazard detected (yay!!!)
        else begin
            forward_a = 2'b00;
        end

        // EX/MEM stage 
        if (regwrite_mem && (wa3_mem != 5'b0) && (wa3_mem == rt_ex)) begin
            forward_b = 2'b10;
        end
        // MEM/WB stage
        else if (regwrite_wb && (wa3_wb != 5'b0) && (wa3_wb == rt_ex)) begin
            forward_b = 2'b01;
        end
        // No hazard detected
        else begin
            forward_b = 2'b00;
        end
    end

endmodule

`endif // FORWARDING