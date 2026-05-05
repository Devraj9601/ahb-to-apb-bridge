`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 10:38:20 AM
// Design Name: 
// Module Name: display
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


module display(
    input clk,
    input rst,
    input op_write,
    input [2:0] peripheral,
    input [7:0] data_byte,
    output reg [6:0] seg,
    output reg [3:0] an
);

    reg [15:0] refresh_count;
    reg [1:0] digit_sel;

    wire [3:0] nibble_hi = data_byte[7:4];
    wire [3:0] nibble_lo = data_byte[3:0];

    localparam OP_R = 2'b00;
    localparam OP_W = 2'b01;

    always @(posedge clk) begin
        if (rst)
            refresh_count <= 0;
        else
            refresh_count <= refresh_count + 1;
    end

    always @(*) begin
        digit_sel = refresh_count[15:14];
        an = 4'b1111;
        seg = 7'b1111111;

        case (digit_sel)
            2'b00: begin
                an = 4'b1110;
                seg = hex_to_seg(nibble_lo);
            end
            2'b01: begin
                an = 4'b1101;
                seg = hex_to_seg(nibble_hi);
            end
            2'b10: begin
                an = 4'b1011;
                seg = peripheral_to_seg(peripheral);
            end
            2'b11: begin
                an = 4'b0111;
                seg = op_to_seg(op_write ? OP_W : OP_R);
            end
        endcase
    end

    function [6:0] hex_to_seg;
        input [3:0] value;
        begin
            case (value)
                4'h0: hex_to_seg = 7'b1000000;
                4'h1: hex_to_seg = 7'b1111001;
                4'h2: hex_to_seg = 7'b0100100;
                4'h3: hex_to_seg = 7'b0110000;
                4'h4: hex_to_seg = 7'b0011001;
                4'h5: hex_to_seg = 7'b0010010;
                4'h6: hex_to_seg = 7'b0000010;
                4'h7: hex_to_seg = 7'b1111000;
                4'h8: hex_to_seg = 7'b0000000;
                4'h9: hex_to_seg = 7'b0010000;
                4'hA: hex_to_seg = 7'b0001000;
                4'hB: hex_to_seg = 7'b0000011;
                4'hC: hex_to_seg = 7'b1000110;
                4'hD: hex_to_seg = 7'b0100001;
                4'hE: hex_to_seg = 7'b0000110;
                default: hex_to_seg = 7'b0001110;
            endcase
        end
    endfunction

    function [6:0] peripheral_to_seg;
        input [2:0] value;
        begin
            case (value)
                3'b001: peripheral_to_seg = 7'b1111001; // 1 = LED
                3'b010: peripheral_to_seg = 7'b0100100; // 2 = TIMER
                3'b100: peripheral_to_seg = 7'b0110000; // 3 = UART
                default: peripheral_to_seg = 7'b1111111; // blank
            endcase
        end
    endfunction

    function [6:0] op_to_seg;
        input [1:0] value;
        begin
            case (value)
                OP_W: op_to_seg = 7'b1101010; // approximate 'W'
                default: op_to_seg = 7'b0101111; // approximate 'r'
            endcase
        end
    endfunction



endmodule
