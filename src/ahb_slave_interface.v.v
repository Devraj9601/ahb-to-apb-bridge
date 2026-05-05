`timescale 1ns / 1ps
module ahb_slave_interface(
    input Hclk, Hresetn, Hwrite, Hreadyin,
    input [1:0] Htrans,
    input [31:0] Haddr, Hwdata,
    output reg valid,
    output reg [31:0] Haddr1, Hwdata1,
    output reg Hwritereg,
    output reg [2:0] tempselx
);
    always @(posedge Hclk) begin
        if (~Hresetn) begin
            Haddr1 <= 0;
            Hwdata1 <= 0;
            Hwritereg <= 0;
            valid <= 1'b0;
        end
        else 
            begin
            valid <= 1'b0;

            if (Hreadyin && Htrans[1]) begin
                Haddr1 <= Haddr;
                Hwritereg <= Hwrite;
                if (Hwrite)
                    Hwdata1 <= Hwdata;
                valid <= (Haddr >= 32'h8000_0000 && Haddr < 32'h8C00_0000);
            end
        end
    end

    // Address Decoding
    always @(*) 
        begin
            if (Haddr1 >= 32'h8000_0000 && Haddr1 < 32'h8400_0000)      
                tempselx = 3'b001; // LED
            else if (Haddr1 >= 32'h8400_0000 && Haddr1 < 32'h8800_0000) 
                tempselx = 3'b010; // Timer
            else if (Haddr1 >= 32'h8800_0000 && Haddr1 < 32'h8C00_0000) 
                tempselx = 3'b100; // UART
            else 
                tempselx = 3'b000;
        end
endmodule
