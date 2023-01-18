`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2021 02:29:18 PM
// Design Name: 
// Module Name: shifter
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

module shifter #(parameter N=32) (
    input wire signed [N-1:0] IN,           //shift amt can be from 0 to N-1 so num of bits is clog2
    input wire [$clog2(N)-1:0] shamt,      //ceiling log base 2
    input wire left, logical,
    output wire [N-1:0] OUT
    );
    
    assign OUT = left ? (IN << shamt) :
                (logical ? IN >> shamt : IN >>> shamt);
endmodule
