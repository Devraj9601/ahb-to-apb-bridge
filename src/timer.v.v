module apb_timer(
    input clk, rst, sel, Pwrite, Penable,
    input [31:0] Pwdata,
    output reg tick,
    output [31:0] Prdata
);

    reg [31:0] count, delay;

    always @(posedge clk) begin
        if (rst) 
          begin
            count <= 0;
            delay <= 100000000;
            tick <= 0;
          end
        else if (sel && Pwrite && Penable)
            delay <= Pwdata;
        else if (count >= delay) begin
            count <= 0;
            tick <= 1;
        end
        else begin
            count <= count + 1;
            tick <= 0;
        end
    end

    assign Prdata = delay;
endmodule
