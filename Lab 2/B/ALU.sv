`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2021 09:22:25 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`default_nettype none

module ALU #(parameter N=32) (
    input wire [N-1:0] A, B,
    output wire [N-1:0] R,
    input wire [4:0] ALUfn,
    output wire FlagN, FlagV, FlagC, FlagZ
    );
    
    wire subtract, bool1, bool0, shft, math;
    assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];       //separate ALUfn into named bits
    
    wire [N-1:0] addsubResult, shiftResult, logicalResult; 
    wire compResult;          //Results from 3 ALU components
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagV, FlagC);
    shifter #(N) S(B, A[$clog2(N)-1:0], ~bool1,  ~bool0, shiftResult);
    logical #(N) L(A, B, {bool1, bool0}, logicalResult);
    comparator C(FlagN, FlagV, FlagC, bool0, compResult);
    
    assign R =  (~shft & math) ? addsubResult:                               //4-way multiplexer to select result
                (shft & ~math) ? shiftResult:
                (~shft & ~math) ? logicalResult: 
                {{(N-1){1'b0}}, compResult};
                
    assign FlagZ = ~|R;                      //is set if all bits are 0                        //reduction operator            
endmodule
