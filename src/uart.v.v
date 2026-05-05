module apb_uart(
    input clk, rst,
    input sel, Pwrite, Penable,
    input [31:0] Pwdata,
    output reg tx,
    output reg baud_tick,
    output [31:0] Prdata
);

    reg [13:0] baud_count;
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg active;
    reg [7:0] tx_fifo [0:7];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] fifo_count;

    initial tx = 1;

    always @(posedge clk) 
      begin
        if (rst) 
            begin
                baud_count <= 0;
                baud_tick <= 0;
            end
        else if(active) 
                begin
                    if (baud_count == 10416) 
                        begin
                            baud_count <= 0;
                            baud_tick <= 1;
                        end 
                    else 
                        begin
                            baud_count <= baud_count + 1;
                            baud_tick <= 0;
                        end
                end 
          else 
                begin
                     baud_count <= 0;
                     baud_tick <= 0;
                end
     end

    always @(posedge clk) 
      begin
        if (rst) 
            begin
                tx <= 1;
                active <= 0;
                bit_index <= 0;
                shift_reg <= 10'b1111111111;
                wr_ptr <= 0;
                rd_ptr <= 0;
                fifo_count <= 0;
            end

        else begin
            if (sel && Pwrite && Penable) begin
                if (!active && (fifo_count == 0)) begin
                    // Start the very first byte immediately.
                    shift_reg <= {1'b1, Pwdata[7:0], 1'b0};
                    active <= 1;
                    bit_index <= 0;
                    tx <= 1;
                end
                else if (fifo_count < 8) begin
                    // Queue later bytes while a transfer is already in progress.
                    tx_fifo[wr_ptr] <= Pwdata[7:0];
                    wr_ptr <= wr_ptr + 1;
                    fifo_count <= fifo_count + 1;
                end
            end

            if (active && baud_tick) begin
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                if (bit_index == 9) begin
                    active <= 0;
                    bit_index <= 0;
                    tx <= 1;
                end 
                else begin
                    bit_index <= bit_index + 1;
                end
            end

            if (!active && (fifo_count != 0)) begin
                shift_reg <= {1'b1, tx_fifo[rd_ptr], 1'b0};
                active <= 1;
                bit_index <= 0;
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
                tx <= 1;
            end
        end
        end

    assign Prdata = {24'd0, tx_fifo[rd_ptr]};

endmodule
