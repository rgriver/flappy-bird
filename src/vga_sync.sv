`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2016 20:33:34
// Design Name: 
// Module Name: vga_sync
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


module vga_sync(
    input logic clk, reset,
    output logic hsync, vsync,
    output logic [10:0] x,
    output logic [9:0] y,
    output logic vidon
    );
    
    parameter HACTIVE = 11'd640;
    parameter HFP = 11'd16;
    parameter HSYN = 11'd96;
    parameter HBP = 11'd48;
    parameter HMAX = 11'd800;
    parameter VACTIVE = 10'd480;
    parameter VFP = 11'd10;
    parameter VSYN = 11'd2;
    parameter VBP = 11'd33;
    parameter VMAX = 11'd525;
    
     
    always @(posedge clk, posedge reset) begin
        if (reset) x <= 11'b0;
        else if (x == HMAX - 1) x <= 11'b0;
        else x <= x + 11'b1;
    end
    
    always @(posedge clk, posedge reset) begin
        if (reset)
            y <= 10'b0;
        else if (x == HMAX - 1) begin
            if (y == VMAX - 1) y <= 10'b0;
            else y <= y + 10'b1; 
        end else y <= y;
    end
    
    assign hsync = ~((x >= HACTIVE + HBP) & (x < HACTIVE + HBP + HSYN));
    assign vsync = ~((y >= VACTIVE + VBP) & (y < VACTIVE + VBP + VSYN));
    assign vidon = ((x < HACTIVE) & (y < VACTIVE));

endmodule
