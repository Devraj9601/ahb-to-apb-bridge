module ahb_gen(
    input clk, rst,
    input Hreadyin,
    input [31:0] Hrdata,
    output reg Hwrite,
    output reg [1:0] Htrans,
    output reg [31:0] Haddr,
    output reg [31:0] Hwdata
);

    localparam [5:0]
        LED_ADDR     = 6'd0,
        LED_DATA     = 6'd1,
        WAIT_0       = 6'd2,
        TIMER_ADDR   = 6'd3,
        TIMER_DATA   = 6'd4,
        WAIT_1       = 6'd5,
        H_ADDR       = 6'd6,
        H_DATA       = 6'd7,
        WAIT_2       = 6'd8,
        E_ADDR       = 6'd9,
        E_DATA       = 6'd10,
        WAIT_3       = 6'd11,
        L1_ADDR      = 6'd12,
        L1_DATA      = 6'd13,
        WAIT_4       = 6'd14,
        L2_ADDR      = 6'd15,
        L2_DATA      = 6'd16,
        WAIT_5       = 6'd17,
        O_ADDR       = 6'd18,
        O_DATA       = 6'd19,
        WAIT_6       = 6'd20,
        READ_ADDR    = 6'd21,
        READ_CAPTURE = 6'd22,
        DONE         = 6'd23;

    localparam [25:0] DEMO_DELAY = 26'd50_000_000;     // only simulation  delay = 50_000_000 --> 5

    reg [5:0] state;
    reg [25:0] delay_count;
    reg [31:0] readback_data;

    always @(posedge clk) begin
        if (rst) begin
            state <= LED_ADDR;
            delay_count <= 0;
            readback_data <= 0;
            Hwrite <= 1'b0;
            Htrans <= 2'b00;
            Haddr <= 32'd0;
            Hwdata <= 32'd0;
        end
        else if (delay_count != 0) begin
            delay_count <= delay_count - 1'b1;
            Hwrite <= 1'b0;
            Htrans <= 2'b00;
            Haddr <= 32'd0;
            Hwdata <= 32'd0;
        end
        else if (Hreadyin) begin
            case (state)
                LED_ADDR: begin
                    Haddr <= 32'h8000_0000;
                    Hwdata <= 32'h0000_000A;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= LED_DATA;
                end

                LED_DATA: begin
                    Haddr <= 32'h8000_0000;
                    Hwdata <= 32'h0000_000A;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_0;
                end

                WAIT_0: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= TIMER_ADDR;
                end

                TIMER_ADDR: begin
                    Haddr <= 32'h8400_0000;
                    Hwdata <= 32'h02FAF000;                 // 
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= TIMER_DATA;
                end

                TIMER_DATA: begin
                    Haddr <= 32'h8400_0000;
                    Hwdata <= 32'h02FAF000;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_1;         end

                WAIT_1: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= H_ADDR;
                end

                H_ADDR: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_0048;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= H_DATA;
                end

                H_DATA: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_0048;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_2;
                end

                WAIT_2: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= E_ADDR;
                end

                E_ADDR: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_0045;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= E_DATA;
                end

                E_DATA: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_0045;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_3;
                end

                WAIT_3: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= L1_ADDR;
                end

                L1_ADDR: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004C;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= L1_DATA;
                end

                L1_DATA: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004C;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_4;
                end

                WAIT_4: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= L2_ADDR;
                end

                L2_ADDR: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004C;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= L2_DATA;
                end

                L2_DATA: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004C;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_5;
                end

                WAIT_5: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= O_ADDR;
                end

                O_ADDR: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004F;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b10;
                    state <= O_DATA;
                end

                O_DATA: begin
                    Haddr <= 32'h8800_0000;
                    Hwdata <= 32'h0000_004F;
                    Hwrite <= 1'b1;
                    Htrans <= 2'b00;
                    state <= WAIT_6;
                end

                WAIT_6: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    delay_count <= DEMO_DELAY;
                    state <= READ_ADDR;
                end

                READ_ADDR: begin
                    Haddr <= 32'h8400_0000;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b10;
                    state <= READ_CAPTURE;
                end

                READ_CAPTURE: begin
                    Haddr <= 32'h8400_0000;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    readback_data <= Hrdata;
                    delay_count <= DEMO_DELAY;
                    state <= DONE;
                end

                default: begin
                    Haddr <= 32'd0;
                    Hwdata <= 32'd0;
                    Hwrite <= 1'b0;
                    Htrans <= 2'b00;
                    readback_data <= Hrdata;
                    state <= DONE;
                end
            endcase
        end
    end

endmodule
