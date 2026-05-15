`timescale 1ns/100ps

module tb_controller();

    logic [5:0] op;
    logic [5:0] funct;
    
    logic       regwrite;
    logic       regdst;
    logic       alusrc;
    logic       branch;
    logic       memwrite;
    logic       memtoreg;
    logic       jump;
    logic [3:0] alucontrol;
    logic       is_repeat;

    // Instantiate Unit Under Test
    controller dut (.*);

    initial begin
        op = 6'b000000; funct = 6'b100000; #10;
        $display("t=%0t | ADD  -> RegWrite: %b, ALUControl: 0b%4b, Branch Out: %b", $time, regwrite, alucontrol, branch);
        op = 6'b000100; funct = 6'b000000; #10;
        $display("t=%0t | BEQ  -> RegWrite: %b, ALUControl: 0b%4b, Branch Out: %b", $time, regwrite, alucontrol, branch);
        op = 6'b000000; funct = 6'b111111; #10;
        $display("t=%0t | MADD -> RegWrite: %b, ALUControl: 0b%4b, IsRepeat: %b", $time, regwrite, alucontrol, is_repeat);
        op = 6'b011111; funct = 6'b000000; #10;
        $display("t=%0t | REPT -> RegWrite: %b, ALUControl: 0b%4b, IsRepeat: %b", $time, regwrite, alucontrol, is_repeat);

        $finish;
    end

endmodule