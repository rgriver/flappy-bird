`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2016 15:30:28
// Design Name: 
// Module Name: flappy_bird_top
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


module flappy_bird_top(
    input clk,
    input btnC, btnU, btnL,
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync,
    output [1:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    );
    
    logic clk190, vgaclk;
    
    assign led[1] = btnU;
    
    logic [10:0] x;
    logic [10:0] bird_y;
    logic [9:0] y;
    logic vid_on, bird_on, ground_on, logo_on;
    logic up;
    logic refresh;
    logic collision;
    logic [1:0] state;
    logic [11:0] bird_rgb, ground_rgb, logo_rgb, back_rgb, pipe_rgb;
    logic [7:0] score;
    
    rgb_multiplexing u1(
        .bird_on(bird_on), .vid_on(vid_on), .ground_on(ground_on),
        .pipe_on(pipe_on), .logo_on(logo_on),
        .back_on(back_on),
        .rgb({vgaRed, vgaGreen, vgaBlue}),
        .bird_rgb(bird_rgb),
        .ground_rgb(ground_rgb),
        .logo_rgb(logo_rgb),
        .back_rgb(back_rgb),
        .pipe_rgb(pipe_rgb)
        );
        
    bird u2(
        .clk(vgaclk), .reset(btnL), .up(up),
        .x(x), .y(y), 
        .bird_on(bird_on),
        .pipe_on(pipe_on),
        .flight(led[0]), .bird_y(bird_y), .refresh(refresh),
        .collision(collision),
        .state(state),
        .bird_rgb(bird_rgb)
        );
        
    vga_sync u3(
        .clk(vgaclk), .reset(btnC), .hsync(Hsync), .vsync(Vsync),
        .x(x), .y(y), .vidon(vid_on)
        );
        
    seven_segment u4(
        .clk(clk190), .reset(btnC), .data(score),//{5'b00000, bird_y}
        .seg(seg), .an(an), .dp(dp)
        );
        
    clk_divider u5(
        .clk(clk), .clk190(clk190), .reset(btnC), .clk25meg(vgaclk)
        );
        
    pulse_gen u6(
        .clk(vgaclk), .reset(btnC), .sigin(btnU), .sigout(up),
        .refresh(refresh)
        );
        
    ground u7(
        .clk(vgaclk), .reset(btnL),
        .x(x),
        .y(y), 
        .ground_on(ground_on),
        .ground_rgb(ground_rgb),
        .refresh(refresh)
        );
        
    pipes u8(
        .clk(clk), .reset(btnL), .x(x), .y(y),
        .vgaclk(vgaclk),
        .pipe_on(pipe_on), .refresh(refresh),
        .pipe_rgb(pipe_rgb),
        .collision(collision),
        .state(state),
        .score(score)
        );
        
    logo u9(
        .x(x),
        .y(y),
        .state(state),
        .logo_rgb(logo_rgb),
        .logo_on(logo_on)
        );
        
    background u10(
        .clk(vgaclk),
        .x(x), .y(y),
        .back_on(back_on),
        .back_rgb(back_rgb)
        );
    
endmodule
