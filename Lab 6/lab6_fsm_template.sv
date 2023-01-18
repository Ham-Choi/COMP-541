//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/24/2021
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm_NAME(
    input wire clk,
    input wire RESET,                     // Comment this line out if no RESET input
    input wire in1, in2, in3, ...         // List of inputs to FSM
    output logic out1, out2, out3, ...    // List of outputs of FSM
                                          // The outputs will actually be synthesized as combinational logic!
    );


    // =========================================================================

    // The first part is our state encoding.  There are two options.
    // (1) You enumerate states, and the compiler decides state encoding.

    enum { STATE0, STATE1, STATE2, ... etc. } state, next_state;

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
      if (RESET == 1) state <= STATE_??;    // Remove the "if" part if no RESET input
      else state <= next_state;


    // =========================================================================

    // The next part is definition of the next stage logic.

    // Define next_state logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            STATE1: next_state <= ( check inputs == ??) ? ... : ...;  // include only inputs that matter
            STATE2: next_state <= ...;
            STATE3: ...
            default: next_state <= ...;   // must have default
      endcase



    // =========================================================================

    // The final part is definition of the output logic.

    // Define output logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            STATE1: {out1, out2, out3, ...} <= ...;  // all outputs must be specified
            STATE2: {out1, out2, out3, ...} <= ...;  // if Moore type:  outputs will depend only on state
            STATE3: ...                              // if Mealy type:  outputs will depend also on inputs
           default: {out1, out2, out3, ...} <= ...;  // must have default
      endcase

endmodule
