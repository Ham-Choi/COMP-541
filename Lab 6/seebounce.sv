//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/24/2021
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module seebounce(
    input wire X,
    input wire clk,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );


    // For Part 1, uncomment the two lines below to include a debouncer
    // wire cleanX;
    // debouncer #(...) d(X, clk, cleanX);    // Choose parameter N appropriately
    // Use cleanX instead of X below (in the always_ff block)


   logic [31:0] numBounces = 0;

   always_ff @(posedge X)
      numBounces <= numBounces + 1'b 1;    // Let's count number of bounces

   display8digit mydisplay(numBounces, clk, segments, digitselect);
		
endmodule
