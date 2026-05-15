`ifndef LOOP_CTRL
`define LOOP_CTRL

`timescale 1ns/100ps

module loop_ctrl (
    input  logic        clk,
    input  logic        reset,

    input  logic        is_repeat_id,  
    input  logic [15:0] loop_size_id,      // Number of instructions in the loop block
    input  logic [15:0] loop_count_id,     // Number of iterations to run the loop
    input  logic [31:0] pc_plus4_id,       
    
    input  logic [31:0] current_pc_if,

    output logic        loop_active,      
    output logic [31:0] loop_target_pc    
);

    // Internal architectural state elements
    logic        active_q;
    logic [31:0] start_pc_q;
    logic [31:0] end_pc_q;
    logic [15:0] count_q;

    // Combinational evaluation logic
    logic loop_end_reached;
    assign loop_end_reached = active_q && (current_pc_if == end_pc_q);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            active_q   <= 1'b0;
            start_pc_q <= 32'b0;
            end_pc_q   <= 32'b0;
            count_q    <= 16'b0;
        end else if (is_repeat_id && !active_q) begin
            // Initialize tracking parameters
            active_q   <= (loop_count_id > 16'd1); 
            start_pc_q <= pc_plus4_id;          
            end_pc_q   <= pc_plus4_id + (loop_size_id << 2);
            count_q    <= loop_count_id - 16'd1;  
        end else if (loop_end_reached) begin
            if (count_q == 16'd1) begin
                // Final loop iteration complete, restore standard pipeline progression
                active_q <= 1'b0;
            end else begin
                // Decrement count and loop back around
                count_q  <= count_q - 16'd1;
            end
        end
    end

    // Assign control signals to drive Fetch muxes
    assign loop_active    = loop_end_reached;
    assign loop_target_pc = start_pc_q;

endmodule

`endif // LOOP_CTRL