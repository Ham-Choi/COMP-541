`timescale 1ns / 1ps

module datapath #(
    parameter Nloc = 32,                      // Number of memory locations
    parameter Dbits = 32                       // Number of bits in data
)(
    input wire [$clog2(Nloc)-1 : 0] ReadAddr1, ReadAddr2, WriteAddr,
    input wire [Dbits-1 : 0] WriteData,
    input wire RegWrite,
    input wire [4:0] ALUFN,
    input wire clock,
    output wire [Dbits-1 : 0] ReadData1, ReadData2,
    output wire [Dbits-1 : 0] ALUResult,
    output wire FlagZ
    );
    //feeding into register file
    register_file register(clock, RegWrite, ReadAddr1, ReadAddr2, WriteAddr, WriteData, ReadData1, ReadData2);
    //feeding into ALU
    ALU alu(.A(ReadData1), .B(ReadData2), .R(ALUResult), .ALUfn(ALUFN), .FlagZ(FlagZ));
    
    
endmodule
