`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2016 15:57:03
// Design Name: 
// Module Name: logo
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


module logo(
    input [10:0] x,
    input [9:0] y,
    input [1:0] state,
    output logic [11:0] logo_rgb,
    output logic logo_on
    );
    
    logic [89:0] bw2 [0:24];
    logic [89:0] bw1 [0:24];
    logic [89:0] bw0 [0:24];
    
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/logo/bw2.txt", bw2);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/logo/bw1.txt", bw1);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/logo/bw0.txt", bw0);
    
    logic [89:0] line_bw2;
    logic [89:0] line_bw1;
    logic [89:0] line_bw0;
    
    assign line_bw2 = bw2[y[9:2] - 10];
    assign line_bw1 = bw1[y[9:2] - 10];
    assign line_bw0 = bw0[y[9:2] - 10];
    
    always_comb begin
        logo_rgb = 12'h000;
        logo_on = 0;
        if ((y[9:2] >= 10) && (y[9:2] < 35) && (x[10:2] >= 36) && (x[10:2] < 126) && (state == 0)) begin
            case ({line_bw0[125 - x[10:2]], line_bw1[125 - x[10:2]]})
                2'b10: begin
                    logo_rgb = 12'h000;
                    logo_on = 1;
                end
                2'b01: begin
                    logo_rgb = 12'hfff;
                    logo_on = 1;
                end
                default: begin
                    logo_on = 0;
                    logo_rgb = 12'h000;
                end
            endcase
        end
    end
    
    
endmodule
