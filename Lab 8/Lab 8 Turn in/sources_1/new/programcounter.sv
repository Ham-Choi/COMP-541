`timescale 1ns / 1ps
`default_nettype none

module programcounter(
    input wire clk,reset,enable,
    input wire [31:0] D,
    output wire [31:0] pc
    );
    
    logic [31:0] Q = 32'h0040_0000;
    
    always_ff @(posedge clk or posedge reset)       //checks for clock tick or if reset is 1
    begin  
        if (reset)
            Q <= 32'h0040_0000;             //reinitialized
        else if (enable)
            Q <= D;
    end
    
    assign pc = Q;            
endmodule
