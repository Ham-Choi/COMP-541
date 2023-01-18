//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/24/2021
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm(
    input wire clk,
   // input wire RESET,                     // Comment this line out if no RESET input
    input wire btnu, btnd, btnc,      // List of inputs to FSM
    output logic countup, paused    // List of outputs of FSM                                     // The outputs will actually be synthesized as combinational logic!
    );


    // =========================================================================

    // The first part is our state encoding.  There are two options.
    // (1) You enumerate states, and the compiler decides state encoding.

    enum { COUNTINGUP, COUNTINGDOWN, PAUSINGUP, PAUSINGDOWN, RESUMINGUP, RESUMINGDOWN, PAUSEDUP, PAUSEDDOWN} state, next_state;

    // -- OR --   
    // (2) You can specify state encoding explicitly.

    // enum { STATE0=2'b00, STATE1=2'b01, STATE2=2'b10, ... etc. } state, next_state;

    // Be sure that the initial (i.e. startup) state has the encoding of 0 or,
    // if you are leaving the encoding to the compiler, then the initial state
    // should be the first one listed.


    // =========================================================================

    // The next part is instantiation of the storage elements.

    // Instantiate the state storage elements (flip-flops)
    
    always_ff @(posedge clk)
     state <= next_state;


    // =========================================================================

    // The next part is definition of the next stage logic.

    // Define next_state logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            COUNTINGUP: next_state <= (btnc) ? PAUSINGUP : (btnd) ? COUNTINGDOWN : COUNTINGUP;  // include only inputs that matter
            PAUSINGUP: next_state <= (btnc) ? PAUSINGUP : PAUSEDUP;
            PAUSEDUP: next_state <= (btnc) ? RESUMINGUP : (btnd) ? PAUSEDDOWN: PAUSEDUP;
            RESUMINGUP: next_state <= (btnc) ? RESUMINGUP : COUNTINGUP;
            
            COUNTINGDOWN: next_state <= (btnc) ? PAUSINGDOWN: (btnu) ? COUNTINGUP: COUNTINGDOWN;
            PAUSINGDOWN: next_state <= (btnc) ? PAUSINGDOWN: PAUSEDDOWN;
            PAUSEDDOWN: next_state <= (btnc) ? RESUMINGDOWN: (btnu) ? PAUSEDUP: PAUSEDDOWN;
            RESUMINGDOWN: next_state <= (btnc) ? RESUMINGDOWN: COUNTINGDOWN;
            default: next_state <= state;   // must have default
      endcase



    // =========================================================================

    // The final part is definition of the output logic.

    // Define output logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            COUNTINGUP: {countup, paused} <= {1'b1, 1'b0};  // all outputs must be specified
            PAUSINGUP: {countup, paused} <= {1'b1, 1'b1};  // if Moore type:  outputs will depend only on state
            PAUSEDUP: {countup, paused} <= {1'b1, 1'b1};                              // if Mealy type:  outputs will depend also on inputs
            RESUMINGUP: {countup, paused} <= {1'b1, 1'b0};
            COUNTINGDOWN: {countup, paused} <= {1'b0, 1'b0};
            PAUSINGDOWN: {countup, paused} <= {1'b0, 1'b0};
            PAUSEDDOWN: {countup, paused} <= {1'b0, 1'b1};
            RESUMINGDOWN: {countup, paused} <= {1'b0, 1'b0};
           default: {countup, paused} <= {1'b1, 1'b0};  // must have default
      endcase

endmodule
