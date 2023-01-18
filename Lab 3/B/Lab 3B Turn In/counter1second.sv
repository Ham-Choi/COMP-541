`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 11:48:38 PM
// Design Name: 
// Module Name: counter1second
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

module counter1second(
    input wire clock,
    output logic [3:0] value
    );
    logic [31:0] counter;                   //32 bit counter
    always_ff @(posedge clock) begin
        counter <= counter+1;               //increment counter
        value <= counter[30:27];            //get 4-bits for output
    end    
endmodule
