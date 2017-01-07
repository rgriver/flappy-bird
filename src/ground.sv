`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2016 16:42:12
// Design Name: 
// Module Name: ground
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
  

module ground(
    input [9:0] y,
    output ground_on
    );
    
    assign ground_on = (y > 464) && (y <= 479);
    
endmodule
