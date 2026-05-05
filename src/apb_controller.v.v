`timescale 1ns / 1ps

module apb_controller(
    input Hclk, Hresetn, valid, Hwritereg,
    input [31:0] Haddr1, Hwdata1,
    input [2:0] tempselx,
    output reg Pwrite, Penable,
    output reg [2:0] Pselx,
    output reg [31:0] Paddr, Pwdata,
    output reg Hreadyout,
    output reg [3:0] current_state // To monitor in ILA
);
    localparam RESET_ST = 4'd0,
               IDLE     = 4'd1,
               READ     = 4'd2,
               RENABLE  = 4'd3,
               WWAIT    = 4'd4,
               WRITE    = 4'd5,
               WENABLE  = 4'd6;

    reg [3:0] ps, ns;
    reg [31:0] latched_addr, latched_wdata;
    reg [2:0] latched_sel;

    // 1. Present State Logic (Sequential)
    always @(posedge Hclk or negedge Hresetn) begin
        if (!Hresetn) begin
            ps <= RESET_ST;
            latched_addr <= 32'd0;
            latched_wdata <= 32'd0;
            latched_sel <= 3'b000;
        end
        else 
            begin
            ps <= ns;

            if (valid) 
            begin
                latched_addr <= Haddr1;
                latched_sel <= tempselx;
                latched_wdata <= Hwdata1;
            end

           end
        end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        case(ps)
            RESET_ST: ns = IDLE;
            IDLE:    ns = (!valid) ? IDLE : (Hwritereg ? WWAIT : READ);
            READ:    ns = RENABLE;
            RENABLE: ns = IDLE;
            WWAIT:   ns = WRITE;
            WRITE:   ns = WENABLE;
            WENABLE: ns = IDLE;

            default: ns = IDLE;
        endcase
    end

    // 3. Output Logic (Combinational)
    always @(*) begin
        // Default values to prevent latches
        Pselx     = 0; 
        Penable   = 0; 
        Pwrite    = 0; 
        Hreadyout = 1;
        Paddr     = latched_addr; 
        Pwdata    = latched_wdata;
        current_state = ps;

        case(ps)
            READ: begin
                Pselx = latched_sel; 
                Pwrite = 0; 
                Hreadyout = 0; 
            end

            RENABLE: begin 
                Pselx = latched_sel;
                Penable = 1;
                Pwrite = 0; 
                Hreadyout = 1; 
            end

            WWAIT: begin 
                Hreadyout = 0; 
            end

            WRITE: begin
                Pselx = latched_sel; 
                Pwrite = 1; 
                Hreadyout = 0; 
            end

            WENABLE: begin
                Pselx = latched_sel;
                Penable = 1;
                Pwrite = 1;
                Hreadyout = 1; 
            end
        endcase
    end

endmodule
