`timescale 1ns / 1ps
`default_nettype none

module stopwatch(
    input wire clk,
    input wire BTNU, BTND, BTNC,
    output wire [7:0] segments, digitselect
    );
    
    //debouncing button presses
    wire upClean, downClean, centerClean;
    debouncer #(20) up(BTNU, clk, upClean);
    debouncer #(20) down(BTND, clk, downClean);
    debouncer #(20) center(BTNC, clk, centerClean);
    
    //fsm
    logic countup,paused;
    fsm fsmStart(clk, upClean, downClean, centerClean, countup, paused);
    
    logic [31:0] val;
    updowncounter uDCount(countup, paused, clk, val);
    
    
    display8digit mydisplay(val, clk, segments, digitselect);
    
endmodule
