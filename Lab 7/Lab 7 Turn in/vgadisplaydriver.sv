`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver #(
    parameter Nloc,
    parameter Dbits,
    parameter bmem_init
    )(
    input wire clk,
    input wire [Dbits-1:0] charcode,
    output wire [11:0] RGB,
    output wire hsync, vsync,
    output wire [$clog2(Nloc)-1:0] addr
    
    );
    
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);
    
    assign addr = (y[`ybits-1:4] << 5) + (y[`ybits-1:4] << 3) + x[`xbits-1:4];
    
    wire [$clog2(Nloc)-1:0] bitaddr;
    assign bitaddr = {charcode, x[3:0], y[3:0]};
    
    wire [Dbits-1:0] color;
    bitmapmem # (Nloc, Dbits, bmem_init) bmap(bitaddr, color);
    
    assign RGB = (activevideo) ? color : 11'b0;
endmodule
