`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2016 04:22:01
// Design Name: 
// Module Name: background
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


module background(
    input logic clk,
    input logic [10:0] x,
    input logic [9:0] y,
    output logic back_on,
    output logic [11:0] back_rgb
    );
    
    logic [16:0] addr;
    
//    always_ff @(posedge clk) begin
//        if (x == 476)
//            addr <= 477*y;
//        else if (x > 476)
//            addr <= addr + 1;
//        else
//            addr <= x + (477*y);
//    end
    
    always_ff @(posedge clk) begin
        if (x == 476)
            addr <= 477*(y - 286);
        else if (x == 640)
            addr <= 477*(y - 285);
        else if (x < 640)
            addr <= addr + 1;
    end
    
    assign back_on = (y >= 286) && (y < 440);
    
    background_rom backrom(
        .clka(clk),
        .addra(addr),
        .douta(back_rgb)
        );
    
endmodule
