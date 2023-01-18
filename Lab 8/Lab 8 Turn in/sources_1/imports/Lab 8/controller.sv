`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/15/2021
//
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none

// These are non-R-type.  OPCODES defined here:

`define LW     6'b100011
`define SW     6'b101011

`define ADDI   6'b001000
`define ADDIU  6'b001001     // NOTE:  addiu *does* sign-extend the imm
`define SLTI   6'b001010
`define SLTIU  6'b001011
`define ORI    6'b001101
`define LUI    6'b001111
`define ANDI   6'b001100
`define XORI   6'b001110

`define BEQ    6'b000100
`define BNE    6'b000101
`define J      6'b000010
`define JAL    6'b000011


// These are all R-type, i.e., OPCODE=0.  FUNC field defined here:

`define ADD    6'b100000
`define ADDU   6'b100001
`define SUB    6'b100010
`define AND    6'b100100
`define OR     6'b100101
`define XOR    6'b100110
`define NOR    6'b100111
`define SLT    6'b101010
`define SLTU   6'b101011
`define SLL    6'b000000
`define SLLV   6'b000100
`define SRL    6'b000010
`define SRLV   6'b000110 
`define SRA    6'b000011
`define SRAV   6'b000111 
`define JR     6'b001000
`define JALR   6'b001001 


module controller(

// DO NOT CHANGE

   input  wire enable,
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output wire [1:0] pcsel,
   output wire [1:0] wasel, 
   output wire sgnext,
   output wire bsel,
   output wire [1:0] wdsel, 
   output logic [4:0] alufn,      // will become wire because updated in always_comb
   output wire wr,
   output wire werf, 
   output wire [1:0] asel
   ); 

// CHANGE below by filling in the missing pieces


  assign pcsel = ((op == 6'b0) & ((func == `JR) | (func == `JALR))) ? 2'b11   // controls 4-way multiplexer
               : ((op == `J) | (op == `JAL)) ? 2'b10
               : (((op == `BEQ) & Z) | ((op == `BNE) & ~Z)) ? 2'b01             // for beq/bne check Z flag!
               : 2'b00;

  logic [9:0] controls;                // will become wires because of always_comb
  wire _werf_, _wr_;                   // need to be ANDed with enable (to freeze processor)
  assign werf = _werf_ & enable;       // turn off register writes when processor is disabled
  assign wr = _wr_ & enable;           // turn off memory writes when processor is disabled
 
  assign {_werf_, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sgnext, _wr_} = controls[9:0];

  always_comb
     case(op)                                     // non-R-type instructions
        `LW: controls <= 10'b1_10_01_00_1_1_0;     // LW
        `SW: controls <= 10'b0_10_01_00_1_1_1;     // SW
      `ADDI: controls <= 10'b1_01_01_00_1_1_0;     // ADDI
     `ADDIU: controls <= 10'b1_01_01_00_1_1_0;                                        // ADDIU
      `SLTI: controls <= 10'b1_01_01_00_1_1_0;                                        // SLTI        
       `ORI: controls <= 10'b1_01_01_00_1_0_0;     // ORI
       `SLTIU: controls <= 10'b1_01_01_00_1_1_0;
       `LUI: controls <= 10'b1_01_01_10_1_x_0;
       `ANDI: controls <= 10'b1_01_01_00_1_0_0;
       `XORI: controls <= 10'b1_01_01_00_1_0_0;
       `BEQ: controls <= 10'b0_xx_xx_00_0_1_0;
       `BNE: controls <= 10'b0_xx_xx_00_0_1_0;
       `J: controls <= 10'b0_xx_xx_xx_x_0_0;
       `JAL: controls <= 10'b1_00_10_xx_0_0_0;      // add remaining non-R-type instructions here
      6'b000000:                                    
         case(func)                              // R-type
             `ADD: controls <= 10'b1_01_00_00_0_0_0;
            `ADDU: controls <= 10'b1_01_00_00_0_x_0; // ADD and ADDU
             `SUB: controls <= 10'b1_01_00_00_0_x_0; // SUB
             `AND: controls <= 10'b1_01_00_00_0_0_0;
             `OR: controls <= 10'b1_01_00_00_0_0_0;
             `XOR: controls <= 10'b1_01_00_00_0_0_0;
             `NOR: controls <= 10'b1_01_00_00_0_0_0;
             `SLT: controls <= 10'b1_01_00_00_0_0_0;
             `SLTU: controls <= 10'b1_01_00_00_0_0_0;
             `SLL: controls <= 10'b1_01_00_01_0_0_0;
             `SLLV: controls <= 10'b1_01_00_00_0_0_0;
             `SRL: controls <= 10'b1_01_00_01_0_0_0;
             `SRLV: controls <= 10'b1_01_00_00_0_x_0;
             `SRA: controls <= 10'b1_01_00_01_0_0_0;
             `SRAV: controls <= 10'b1_01_00_00_0_x_0;
             `JR: controls <= 10'b0_xx_xx_00_1_0_0;
             `JALR: controls <=10'b1_00_00_00_1_0_0;// add remaining R-type instructions here
            default:   controls <= 10'b0_xx_xx_xx_x_x_0; // unknown instruction, turn off register and memory writes
         endcase
      default: controls <= 10'b0_xx_xx_xx_x_x_0;         // unknown instruction, turn off register and memory writes
    endcase
    

  always_comb
    case(op)                        // non-R-type instructions
        `LW: alufn <= 5'b0xx01;                          // LW
        `SW: alufn <= 5'b0xx01;                          // SW
      `ADDI: alufn <= 5'b0xx01;                          // ADDI
     `ADDIU: alufn <= 5'b0xx01;      // ADDIU
      `SLTI: alufn <= 5'b1x011;      // SLTI
       `BEQ: alufn <= 5'b1xx01;                          // BEQ
       `BNE: alufn <= 5'b1xx01;         // BNE
       `SLTIU: alufn <= 5'b1x111;
       `ORI: alufn <= 5'bx0100;
       `XORI: alufn <= 5'bx1000;
       `ANDI: alufn <= 5'bx0000;
       `LUI: alufn <= 5'bx0010;
       // add remaining non-R-type instructions here
      6'b000000:                      
         case(func)                 // R-type
             `ADD: alufn <= 5'b0xx01;
            `ADDU: alufn <= 5'b0xx01; // ADD and ADDU
             `SUB: alufn <= 5'b1xx01; // SUB
             `AND: alufn <= 5'bx0000;
             `OR: alufn <= 5'bx0100;
             `XOR: alufn <= 5'bx1000;
             `NOR: alufn <= 5'bx1100;
             `SLT: alufn <= 5'b1x011;
             `SLTU: alufn <= 5'b1x111;
             `SLL: alufn <= 5'bx0010;
             `SLLV: alufn <= 5'bx0010;
             `SRL: alufn <= 5'bx1010;
             `SRLV: alufn <=5'bx1010;
             `SRA: alufn <= 5'bx1110;
             `SRAV: alufn <= 5'bx1110;
             `JALR: alufn <= 5'bxxxxx;      // add remaining R-type instructions here
            default:   alufn <= 5'b xxxxx; // unknown func
         endcase
      default: alufn <= 5'b xxxxx;         // for all other instructions, alufn is a don't-care.
    endcase
    
endmodule
