`timescale 1ns / 1ps
`default_nettype none

module updowncounter(
    input wire countup,
    input wire paused,
    input wire clk,
    output logic [31:0] value
    );
    
    logic [63:0] counter;
    always_ff @(posedge clk) begin
        counter <= countup ? (paused ? counter: counter + 1): (paused ? counter: counter - 1);
        value <= counter[50:19];
    end
    
endmodule