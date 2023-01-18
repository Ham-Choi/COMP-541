`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Montek Singh
// Jan 26, 2021
// 
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none

module adder4bit_test();

    logic [3:0] A;
    logic [3:0] B;
    logic Cin;
    wire [3:0] Sum;
    wire Cout;
    
    adder4bit my4bitadder(A, B, Cin, Sum, Cout);
    
    integer i;
    
    initial begin
        // Initialize Inputs
        A = 0;
        B = 0;
        Cin = 0;

        // Wait 5 ns before changing inputs
        #5;
        
        for(i=0; i<8; i=i+1)
        begin
          #1 A = A + 1; B = B + 2;
        end
        
        #5 $finish;
    end
    
endmodule
