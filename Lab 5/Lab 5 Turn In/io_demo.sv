`timescale 1ns / 1ps
`default_nettype none

module io_demo(
    input wire clk,
    
    //keyboard
    input wire ps2_data,
    input wire ps2_clk,
    
    //sound
    output wire audPWM,
    output wire audEn,
    
    //accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //lights
    output wire [15:0] LED
    );
    
    //keyboard and sound
    wire [31:0] keyb_char;
    keyboard keyb(clk, ps2_clk, ps2_data, keyb_char);
    
    wire [31:0] notes_period[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    
    wire [31:0] period;
    
    assign period = keyb_char == 8'b0001_1101 ? notes_period[0]
                  : keyb_char == 8'b0001_1110 ? notes_period[1]
                  : keyb_char == 8'b0010_0001 ? notes_period[2]
                  : keyb_char == 8'b0010_0010 ? notes_period[3]
                  : keyb_char == 8'b0010_0011 ? notes_period[4]
                  : keyb_char == 8'b0001_0100 ? notes_period[5]
                  : keyb_char == 8'b0001_0101 ? notes_period[6]
                  : keyb_char == 8'b0001_0110 ? notes_period[7] : 0; 
    
    montek_sound_Nexys4 sound(clk, period, audPWM);
    assign audEn = 1;
    
    //accelerometer and lights
    //Accelerometer data
    wire [8:0] accelX, accelY;      // The accelX and accelY values are 9-bit values, ranging from 9'h 000 to 9'h 1FF
    wire [11:0] accelTmp;           // 12-bit value for temperature
    
    accelerometer accel(clk, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
    
    assign LED =    accelY < 9'b0_0010_0000 ? 16'b0000_0000_0000_0001
               :    accelY < 9'b0_0100_0000 ? 16'b0000_0000_0000_0010
               :    accelY < 9'b0_0110_0000 ? 16'b0000_0000_0000_0100  
               :    accelY < 9'b0_1000_0000 ? 16'b0000_0000_0000_1000
               
               :    accelY < 9'b0_1010_0000 ? 16'b0000_0000_0001_0000
               :    accelY < 9'b0_1100_0000 ? 16'b0000_0000_0010_0000
               :    accelY < 9'b0_1110_0000 ? 16'b0000_0000_0100_0000
               :    accelY < 9'b1_0000_0000 ? 16'b0000_0000_1000_0000
               
               :    accelY < 9'b1_0010_0000 ? 16'b0000_0001_0000_0000
               :    accelY < 9'b1_0100_0000 ? 16'b0000_0010_0000_0000
               :    accelY < 9'b1_0110_0000 ? 16'b0000_0100_0000_0000
               :    accelY < 9'b1_1000_0000 ? 16'b0000_1000_0000_0000
               
               :    accelY < 9'b1_1010_0000 ? 16'b0001_0000_0000_0000
               :    accelY < 9'b1_1100_0000 ? 16'b0010_0000_0000_0000
               :    accelY < 9'b1_1110_0000 ? 16'b0100_0000_0000_0000
               :    16'b1000_0000_0000_0000;
                
endmodule
