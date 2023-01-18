`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2021 10:09:56 PM
// Design Name: 
// Module Name: comparator
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

module comparator(
    input wire FlagN, FlagV, FlagC, bool0,
    output wire comparison
    );
    
    // if true, it is signed comparison
    //C flag true if signed
    assign comparison = (bool0) ? ~FlagC : FlagN ^ FlagV;
endmodule
