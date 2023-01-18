`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2021 04:15:12 PM
// Design Name: 
// Module Name: display8digit
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

module display8digit(
    input wire [31:0] val,
    input wire clk, 					// 100 MHz clock
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );

	logic [31:0] c = 0;					// Used for round-robin digit selection on display
	wire [2:0] topeight;
	wire [3:0] value4bit;
	
	always_ff @(posedge clk)
		c <= c + 1'b 1;
	
	assign topeight[2:0] = c[20:17];		// Used for round-robin digit selection on display
	// assign topeight[2:0] = c[25:22];   // Try this instead to slow things down!

	
	assign digitselect[7:0] = ~ (  			// Note inversion
	   topeight == 3'b000 ? 8'b 0000_0001  
     : topeight == 3'b001 ? 8'b 0000_0010
     : topeight == 3'b010 ? 8'b 0000_0100
     : topeight == 3'b011 ? 8'b 0000_1000
     : topeight == 3'b100 ? 8'b 0001_0000
     : topeight == 3'b101 ? 8'b 0010_0000
     : topeight == 3'b110 ? 8'b 0100_0000
     : 8'b 1000_0000 );

	assign digitselect[7:4] = ~ 4'b 0000;      // Since we are not using half of the display
		
	assign value4bit   =   (
		topeight == 3'b000 ? val[3:0]
	  : topeight == 3'b001 ? val[7:4]
   	  : topeight == 3'b010 ? val[11:8]
	  : topeight == 3'b011 ? val[15:12]
	  : topeight == 3'b100 ? val[19:16]
	  : topeight == 3'b101 ? val[23:20]
	  : topeight == 3'b110 ? val[27:24] 
	  : val[31:28] );
	
	hexto7seg myhexencoder(value4bit, segments);

endmodule
