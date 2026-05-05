//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2023
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: tb_dmem
//     Description: Test bench for data memory
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_DMEM
`define TB_DMEM

`timescale 1ns/100ps
`include "dmem.sv"
`include "../clock/clock.sv"

module tb_dmem;
    parameter n = 32; // bit length of registers/memory
    parameter r = 6; // we are only addressing 64=2**6 mem slots in imem
    logic [(n-1):0] readdata, writedata;
    logic [(n-1):0] dmem_addr;
    logic write_enable;
    logic clk, clock_enable;

   initial begin
        $dumpfile("dmem.vcd");
        $dumpvars(0, uut, uut1);
        $monitor("time=%0t write_enable=%b dmem_addr=%h readdata=%h writedata=%h",
            $realtime, write_enable, dmem_addr, readdata, writedata);
    end

    initial begin
        clock_enable = 0;
        write_enable = 0;
        dmem_addr = 0;
        #20 writedata = 0;
        #10 clock_enable = 1;
        
        // Write FFFFFFFF to Address 0
        #20 dmem_addr = 32'h00000000; writedata = 32'hFFFFFFFF;
        #20 write_enable = 1;
        #20 write_enable = 0;
        
        // Write 0000FFFF to Address 4
        #20 dmem_addr = 32'h00000004; writedata = 32'h0000FFFF;
        #20 write_enable = 1;
        #20 write_enable = 0;
        
        // Write 12345678 to Address 8
        #20 dmem_addr = 32'h00000008; writedata = 32'h12345678;
        #20 write_enable = 1;
        #20 write_enable = 0;
        
        #40 $finish;
    end

   dmem #(n, r)uut(
        .clk(clk),
        .write_enable(write_enable),
        .addr(dmem_addr),
        .writedata(writedata),
        .readdata(readdata)
    );
    clock uut1(
        .ENABLE(clock_enable),
        .CLOCK(clk)
    );
endmodule

`endif // TB_IMEM