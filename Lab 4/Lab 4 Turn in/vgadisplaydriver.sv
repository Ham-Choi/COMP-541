//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 9/8/2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"    // Replace this with the 640x480 values for actual implementation

module vgadisplaydriver(
    input wire clk,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;

   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);
   
//   assign red[3:0]   = (activevideo == 1) ? x[3:0] : 4'b0;
//   assign green[3:0] = (activevideo == 1) ? {x[2:1],y[1:0]} : 4'b0;
//   assign blue[3:0]  = (activevideo == 1) ? {y[2:0],1'b0} : 4'b0;

   assign red[3:0]   = (activevideo == 1) ? x[5:2] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? y[5:2] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? x[5:2]+y[5:2] : 4'b0;

endmodule
