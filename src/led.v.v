module apb_led(input clk, rst, sel, Pwrite, Penable,
               input [31:0] Pwdata,
               output reg [3:0] led,
               output [31:0] Prdata);

    always @(posedge clk) begin
        if (rst)
            led <= 0;
        else if (sel && Pwrite && Penable)
            led <= Pwdata[3:0];
    end

    assign Prdata = {28'd0, led};
endmodule
