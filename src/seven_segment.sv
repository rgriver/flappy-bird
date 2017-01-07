`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2016 00:22:52
// Design Name: 
// Module Name: seven_segment
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


module seven_segment(
    input logic clk, reset,
    input logic [7:0] data,
    output logic [6:0] seg,
    output logic [3:0] an,
    output logic dp
    );
    
    logic [1:0] s;	 
    logic [3:0] digit;
    logic [3:0] aen;
    
    logic [7:0] temp;
    logic [15:0] bcd;
    
    always_comb begin
        temp = data;
        bcd = 16'b0;
        repeat (8) begin
            if (bcd[15:12] > 4)
                bcd[15:12] = bcd[15:12] + 3;
            if (bcd[11:8] > 4)
                bcd[11:8] = bcd[11:8] + 3;
            if (bcd[7:4] > 4)
                bcd[7:4] = bcd[7:4] + 3;
            if (bcd[3:0] > 4)
                bcd[3:0] = bcd[3:0] + 3;                
            bcd = {bcd[14:0], temp[7]};
            temp = {temp[6:0], 1'b0};                         
        end
    end
    
    assign dp = 1;
    
    assign aen[3] = bcd[15] | bcd[14] | bcd[13] | bcd[12];
    assign aen[2] = bcd[15] | bcd[14] | bcd[13] | bcd[12] | bcd[11] | bcd[10] | bcd[9] | bcd[8];
    assign aen[1] = bcd[15] | bcd[14] | bcd[13] | bcd[12] | bcd[11] | bcd[10] | bcd[9] | bcd[8] | bcd[7] | bcd[6] | bcd[5] | bcd[4];
    assign aen[0] = 1;
    
    always_comb begin
        case(s)
            0: digit = bcd[3:0]; // s is 0; digit gets assigned 4 bit value assigned to x[3:0]
            1: digit = bcd[7:4]; // s is 1; digit gets assigned 4 bit value assigned to x[7:4]
            2: digit = bcd[11:8];
            3: digit = bcd[15:12];
            default: digit = bcd[3:0];
        endcase
    end    
    
    always_comb begin
        case(digit)
            4'h0: seg = 7'b1000000;////0000 or 'O'
            4'h1: seg = 7'b1111001;////0001
            4'h2: seg = 7'b0100100;////0010
            4'h3: seg = 7'b0110000;////0011
            4'h4: seg = 7'b0011001;////0100
            4'h5: seg = 7'b0010010;////0101
            4'h6: seg = 7'b0000010;////0110
            4'h7: seg = 7'b1111000;////0111
            4'h8: seg = 7'b0000000;////1000
            4'h9: seg = 7'b0010000;////1001
            4'ha: seg = 7'b0001000;
            4'hb: seg = 7'b0000011;
            4'hc: seg = 7'b1000110;
            4'hd: seg = 7'b0100001;
            4'he: seg = 7'b0000110;
            4'hf: seg = 7'b0001110;
            default: seg = 7'bxxxxxxx;
        endcase
    end
      
    always_comb begin
        an = 4'b1111;
        if(aen[s] == 1)
            an[s] = 0;
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            s <= 0;
        else
            s <= s + 1;
    end
    
endmodule
