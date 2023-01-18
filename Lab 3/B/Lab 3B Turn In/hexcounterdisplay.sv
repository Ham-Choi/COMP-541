`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 11:42:09 PM
// Design Name: 
// Module Name: hexcounterdisplay
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

module hexcounterdisplay(
    input wire clock,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );
    assign digitselect = ~(8'b0000_0001);           //invert
    logic [3:0] valtox;                             //temp value to transfer from counter to hex
    counter1second c(clock, valtox);
    hexto7seg h(valtox,segments);
endmodule
