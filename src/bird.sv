`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2016 15:32:13
// Design Name: 
// Module Name: bird
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


module bird(
    input clk, reset,
    input up,
    input logic [10:0] x,
    input logic [9:0] y,
    input logic pipe_on,
    output logic bird_on,
    output logic flight,
    output logic [10:0] bird_y,
    output logic refresh,
    output logic collision,
    output logic [1:0] state,
    output logic [11:0] bird_rgb
    );
    
    logic [10:0] temp_bird_y, temp_bird_x;
    logic temp_flight;
    logic [10:0] temp_delta_y, temp_delta_x;
    
    logic [63:0] dout;
    //logic refresh;
    logic [5:0] addr, col;
    logic square_on;
    logic bird_bit;
    logic [10:0] left_b, right_b, top_b, bottom_b;
    logic [10:0] bird_x;
    logic [10:0] delta_y, delta_x;
    logic [1:0] n_state;
    logic speed_ctrl;
    logic [4:0] bird_count;
    
    
    parameter BIRD_SIZE_Y = 24;//16
    parameter BIRD_SIZE_X = 34;
    parameter NEW_GAME = 0, PLAY = 1, GAME_OVER = 2;
    parameter BIRD_X_INITIAL = 300, BIRD_Y_INITIAL = 250;//200
    
    //logic reach_bottom;
    
    logic [33:0] bw4 [0:23];
    logic [33:0] bw3 [0:23];
    logic [33:0] bw2 [0:23];
    logic [33:0] bw1 [0:23];
    logic [33:0] bw0 [0:23];
    logic [33:0] bw4_b [0:23];
    logic [33:0] bw3_b [0:23];
    logic [33:0] bw2_b [0:23];
    logic [33:0] bw1_b [0:23];
    logic [33:0] bw0_b [0:23];   
    
    
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw4.txt", bw4);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw3.txt", bw3);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw2.txt", bw2);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw1.txt", bw1);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw0.txt", bw0);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw4_b.txt", bw4_b);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw3_b.txt", bw3_b);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw2_b.txt", bw2_b);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw1_b.txt", bw1_b);
    initial $readmemb("C:/Users/Rodrigo Rivera/Documents/Vivado_Projects/flappy_bird_v2/bw0_b.txt", bw0_b);
    
    logic [33:0] line_bw4, line_bw4_b;
    logic [33:0] line_bw3, line_bw3_b;
    logic [33:0] line_bw2, line_bw2_b;
    logic [33:0] line_bw1, line_bw1_b;
    logic [33:0] line_bw0, line_bw0_b;
    
    assign refresh = ((y == 482) && (x == 0));
    //assign reach_bottom = (ball_y + delta_y >= 700);
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            speed_ctrl <= 0;
        end else if (refresh) begin
            speed_ctrl <= speed_ctrl + 1;
        end
    end
    
    //Bird counter
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            bird_count <= 5'b00000;
        end else if (refresh) begin
            bird_count <= bird_count + 1;
        end
    end
    
    //Collision
    always_ff @(posedge clk) begin
        if (reset) begin
            collision <= 0;
        end else if (bird_on & pipe_on & (state == PLAY)) begin
            collision <= 1;
        end
    end
    
    
    always_comb begin
        temp_delta_y = delta_y;
        n_state = state;
        
        case (state)
            NEW_GAME: begin
                if (up) begin
                    n_state = PLAY;
                    temp_delta_y = -7;
                end else begin
                    if (bird_y > BIRD_Y_INITIAL) begin
                        temp_delta_y = temp_delta_y - speed_ctrl;
                    end
                    if (bird_y  < BIRD_Y_INITIAL) begin
                        temp_delta_y = temp_delta_y + speed_ctrl;
                    end
                    if ((bird_y + delta_y + temp_delta_y > BIRD_Y_INITIAL) && (delta_y + bird_y <= BIRD_Y_INITIAL)) begin
                        temp_delta_y = BIRD_Y_INITIAL - bird_y - delta_y + 7;
                    end
                    if ((bird_y + delta_y + temp_delta_y < BIRD_Y_INITIAL) && (delta_y + bird_y >= BIRD_Y_INITIAL)) begin
                        temp_delta_y = bird_y + delta_y - BIRD_Y_INITIAL - 7;
                    end
                end
            end
            PLAY: begin
                if (up) begin
                    temp_delta_y = -7;
                end else if (temp_bird_y == 416) begin//464
                    temp_delta_y = 0;
                    n_state = GAME_OVER;
                end else begin
                    temp_delta_y = temp_delta_y + speed_ctrl; //replace speed_ctrl with 1 to get full speed
                    if ((delta_y + temp_delta_y + bird_y > 416) && (delta_y + bird_y <= 416)) begin
                        temp_delta_y = 416 - bird_y - delta_y;//464
                    end
                    if (collision) begin
                        n_state = GAME_OVER;
                    end
                end
            end
            GAME_OVER: begin
                if (reset) begin
                    n_state = NEW_GAME;
                end else begin
                    temp_delta_y = 4;
                    if ((delta_y + temp_delta_y + bird_y > 416) && (delta_y + bird_y <= 416)) begin //464
                        temp_delta_y = 416 - bird_y - delta_y;
                    end
                end
            end
            default: n_state = NEW_GAME;
        endcase
    end
    

    
    always_comb begin       
        temp_bird_x = bird_x;
        temp_bird_y = bird_y + delta_y;
    end
    
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            bird_y <= BIRD_Y_INITIAL;
            bird_x <= BIRD_X_INITIAL;
        end else if (refresh) begin
            bird_y <= temp_bird_y;
            bird_x <= temp_bird_x;
        end
    end
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            delta_y <= -7;
            delta_x <= 0;
            state <= NEW_GAME;
        end else if (refresh)  begin 
            delta_y <= temp_delta_y;
            state <= n_state;
        end
    end
    
    assign flight = (state == PLAY);
    
    assign addr = y - bird_y;
    assign col = 333 - x;
    
    assign line_bw4 = (bird_count[3]) ? (bw4[addr]) : (bw4_b[addr]);
    assign line_bw3 = (bird_count[3]) ? (bw3[addr]) : (bw3_b[addr]);//*
    assign line_bw2 = (bird_count[3]) ? (bw2[addr]) : (bw2_b[addr]);
    assign line_bw1 = (bird_count[3]) ? (bw1[addr]) : (bw1_b[addr]);
    assign line_bw0 = (bird_count[3]) ? (bw0[addr]) : (bw0_b[addr]);
    
//    always_comb begin
//        bird_on = 0;
//        if ((x >= bird_x) && (x < bird_x + BIRD_SIZE_X) && (y >= bird_y) && (y < bird_y + BIRD_SIZE_Y))
//            bird_on = (line_bw0[col] | line_bw1[col] | line_bw2[col] | line_bw3[col] | line_bw4[col]);
//    end

    always_comb begin
        if ((x >= bird_x) && (x < bird_x + BIRD_SIZE_X) && (y >= bird_y) && (y < bird_y + BIRD_SIZE_Y)) begin
            bird_on = (line_bw0[col] | line_bw1[col] | line_bw2[col] | line_bw3[col] | line_bw4[col]);
        end else if ((x >= bird_x) && (x < bird_x + BIRD_SIZE_X) && (y > 480) && (bird_y > 480)) begin
            bird_on = (line_bw0[col] | line_bw1[col] | line_bw2[col] | line_bw3[col] | line_bw4[col]);
        end else begin
            bird_on = 0;
        end
    end
    
    always_comb begin
        //bird_on = 0;
        bird_rgb = 12'h000;
        if ((x >= bird_x) && (x < bird_x + BIRD_SIZE_X) && (y >= bird_y) && (y < bird_y + BIRD_SIZE_Y)) begin
            
            //bird_on = (line_bw0[col] | line_bw1[col] | line_bw2[col] | line_bw3[col] | line_bw4[col]);
            
            case ({line_bw4[col], line_bw3[col], line_bw2[col], line_bw1[col]})
                4'b1000: bird_rgb = 12'hf70;
                4'b0100: bird_rgb = 12'hfb0;
                4'b0010: bird_rgb = 12'hff0;
                4'b0001: bird_rgb = 12'hfff;
                default: bird_rgb = 12'h000;
            endcase
        end
    end
    
endmodule
