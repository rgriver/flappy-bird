`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2016 21:53:47
// Design Name: 
// Module Name: rgb_multiplexing
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


module rgb_multiplexing(
    input logic vid_on, bird_on, ground_on, pipe_on, logo_on, back_on,
    input [11:0] bird_rgb, ground_rgb, logo_rgb, back_rgb, pipe_rgb,
    output logic [11:0] rgb
    );
    
    
    always_comb begin    
        if (~vid_on)
            rgb = 12'h000;
        else begin
            if (logo_on) 
                rgb = logo_rgb; 
            else if (bird_on)
                rgb = bird_rgb;
            else if (ground_on)
                rgb = ground_rgb;
            else if (pipe_on)
                rgb = pipe_rgb;//12'h0c0;
            else if (back_on)
                rgb = back_rgb;
            else
                rgb = 12'h6bc;
        end
    end
    
endmodule
