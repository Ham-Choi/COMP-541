`timescale 1ns / 1ps
`default_nettype none

module datapath #(
    parameter Nreg,                      // Number of memory locations
    parameter Dbits                       // Number of bits in data
)(
    input wire clk, reset, enable,
    input wire [Nreg-1:0] instr,
    input wire [1:0] pcsel, wasel, wdsel, asel,
    input wire sgnext, bsel, werf,
    input wire [4:0] alufn,
    input wire [Dbits-1:0] mem_readdata,
    output wire [(Nreg-1):0] pc,
    output wire [Dbits-1 : 0] mem_addr, mem_writedata,
    output wire Z
    );
    wire [Dbits-1:0] signImm;
    wire [Dbits-1:0] alu_result;
    wire [Dbits-1:0] ReadData1, ReadData2;
    wire [$clog2(Nreg)-1:0] reg_writeaddr;      
    wire [Dbits-1:0] BT;
    wire [Dbits-1:0] reg_writedata;    
    wire [Dbits-1:0] aluA;   
    wire [Dbits-1:0] aluB;
    wire [Dbits-1:0] newPC,pcIncr;  
      
    /* Field size 6 bits | 5 bits | 5 bits| 5 bits | 5 bits | 6 bits
    op(opcode) | rs (1st reg operand) | rt (2nd reg operand) | rd (reg dest.) | shamt (shift amt) | funct (function code) 
    R-Type(Arithmetic) op | rs | rt | rd | shamt | funct
    I-Type (Tr, Beq, imm) op | rs | rt | addr/imm
    J-Type (Jump) op | target addr    
    */    
    //Branching
    assign BT = (signImm << 2) + pcIncr;
    
    //memory address
    assign mem_addr = alu_result;
    
    //PC counter pcsel
    assign newPC = (pcsel == 2'b11) ? ReadData1 :
        (pcsel == 2'b10) ? {pc[31:28], instr[25:0], 2'b00} :
        (pcsel == 2'b01) ? BT:
        pcIncr;
    programcounter pgcnt(.clk(clk), .reset(reset), .enable(enable), .D(newPC), .pc(pc));
    assign pcIncr = pc + 4; 

    //feeding into register file    
    register_file #(Nreg, Dbits) rf(.clock(clk), .wr(werf), .ReadAddr1(instr[25:21]), 
    .ReadAddr2(instr[20:16]), .WriteAddr(reg_writeaddr), .WriteData(reg_writedata), .ReadData1(ReadData1), .ReadData2(ReadData2));
    
    //feeding into ALU, width == Dbits
    ALU #(.N(Dbits)) alu(.A(aluA), .B(aluB), .R(alu_result), .ALUfn(alufn), .FlagZ(Z));
       
    //[1:0] wasel- Write Address: R-rd 00 or I-rt 01 or LUI 10
    assign reg_writeaddr = (wasel == 2'b00) ? instr[15:11] :
        (wasel == 2'b01) ? instr[20:16] :
        5'b1_1111;
    
    //[1:0] wdsel - Write Data
    assign reg_writedata = (wdsel == 2'b00) ? pcIncr :
        (wdsel == 2'b01) ? alu_result: mem_readdata;
    
    //[1:0] asel - A Select: R-shamt 01 or I-rt 10
    assign aluA = (asel == 2'b00) ? ReadData1 :
        (asel == 2'b01) ? instr [10:6] :
        5'b1_0000;
    
    //[1]sgnext - Sign Extend pad with 16
    assign signImm = (sgnext == 1'b1) ? {{16{instr[15]}}, instr[15:0]} : {16'b0, instr[15:0]};
    
    //[1] bsel - B Select: 1 passes immediate val 0 passes data
    assign aluB = (bsel == 1'b1) ? signImm :
        ReadData2;
    
    //mem_writedata
    assign mem_writedata = ReadData2;
   

endmodule
