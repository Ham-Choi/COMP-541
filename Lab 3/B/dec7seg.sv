//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// Feb 4, 2021
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module dec7seg(
   input wire [3:0] X,
   output wire [7:0] digitselect,
   output wire [7:0] segments
);

  assign digitselect = ~(8'b0000_0001);               // Note inversion
  assign segments = ~(                                // Note inversion
            X == 4'h0 ? 8'b11111100      
          : X == 4'h1 ? 8'b01100000
          : X == 4'h2 ? 8'b11011010
          : X == 4'h3 ? 8'b11110010
          : X == 4'h4 ? 8'b01100110
          : X == 4'h5 ? 8'b10110110
          : X == 4'h6 ? 8'b10111110
          : X == 4'h7 ? 8'b11100000
          : X == 4'h8 ? 8'b11111110
          : X == 4'h9 ? 8'b11110110
          : 8'b00000001 );            // To catch an X that doesn't match any of the above

endmodule
