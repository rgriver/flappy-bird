`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2016 15:33:22
// Design Name: 
// Module Name: bird_rom
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


module bird_rom(
    input [5:0] addr,
    output [63:0] data
    );
    
    logic [15:0] rom [0:15];
    
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird/ball_rom.txt", rom);
    
    assign data = rom[addr];
    
    
    
endmodule
