`timescale 1ns / 1ps

module Top(
    input Hclk,
    input Hresetn,
    output [3:0] LED,
    output tx,
    output [6:0] seg,
    output [3:0] an
    
);

    // On Basys 3, the center push-button is active high.
    // Internally, the bridge logic uses an active-low reset.
    wire reset_btn = Hresetn;
    
    wire Hresetn_int = ~reset_btn;

    wire [31:0] Haddr_gen, Hwdata_gen;
    wire [1:0] Htrans_gen;
    wire Hwrite_gen;

    wire valid;
    wire [31:0] Haddr1, Hwdata1;
    wire Hwritereg;
    wire [2:0] tempselx;

    wire [31:0] Paddr, Pwdata;
    wire [31:0] Prdata, transfer_data;
    wire [2:0] Pselx;
    wire Pwrite, Penable, Hreadyout;
    wire [3:0] current_fsm_state;

    wire [3:0] led_out, pattern_out;
    wire tick;
    wire baud_tick;
    wire [31:0] uart_prdata, led_prdata, timer_prdata;
    reg last_op_write;
    reg [2:0] last_peripheral;
    reg [7:0] last_data_byte;
    wire transfer_active;
    wire display_op_write;
    wire [2:0] display_peripheral;
    wire [7:0] display_data_byte;

    // AHB MASTER
    ahb_gen GEN (
        .clk(Hclk), .rst(reset_btn),
        .Hrdata(Prdata),
        .Hwrite(Hwrite_gen),
        .Htrans(Htrans_gen),
        .Haddr(Haddr_gen),
        .Hwdata(Hwdata_gen),
        .Hreadyin(Hreadyout)
    );

    // SLAVE INTERFACE
    ahb_slave_interface AHBSlave (
        .Hclk(Hclk), .Hresetn(Hresetn_int),
        .Hwrite(Hwrite_gen),
        .Hreadyin(Hreadyout),
        .Htrans(Htrans_gen),
        .Haddr(Haddr_gen),
        .Hwdata(Hwdata_gen),
        .valid(valid),
        .Haddr1(Haddr1),
        .Hwdata1(Hwdata1),
        .Hwritereg(Hwritereg),
        .tempselx(tempselx)
    );

    // APB CONTROLLER
    apb_controller APBControl (
        .Hclk(Hclk), .Hresetn(Hresetn_int),
        .valid(valid),
        .Hwritereg(Hwritereg),
        .Haddr1(Haddr1),
        .Hwdata1(Hwdata1),
        .tempselx(tempselx),
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pselx(Pselx),
        .Paddr(Paddr),
        .Pwdata(Pwdata),
        .Hreadyout(Hreadyout),
        .current_state(current_fsm_state)
    );

    // UART
    apb_uart UART_MOD (
        .clk(Hclk),
        .rst(reset_btn),
        .sel(Pselx[2]),
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pwdata(Pwdata),
        .tx(tx),
        .baud_tick(baud_tick),
        .Prdata(uart_prdata)
    );

    // LED
    apb_led LED_MOD (
        .clk(Hclk),
        .rst(reset_btn),
        .sel(Pselx[0]),
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pwdata(Pwdata),
        .led(led_out),
        .Prdata(led_prdata)
    );

    // TIMER
    apb_timer TIMER_MOD (
        .clk(Hclk),
        .rst(reset_btn),
        .sel(Pselx[1]),
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pwdata(Pwdata),
        .tick(tick),
        .Prdata(timer_prdata)
    );

    // PATTERN
    apb_pattern PATTERN_MOD (
        .clk(Hclk),
        .rst(reset_btn),
        .tick(tick),
        .led_mask(led_out),
        .led_pattern(pattern_out)
    );

    display DISP (
        .clk(Hclk),
        .rst(reset_btn),
        .op_write(display_op_write),
        .peripheral(display_peripheral),
        .data_byte(display_data_byte),
        .seg(seg),
        .an(an)
    );
    
    
    ila_0 ILA_UNIT (
    .clk(Hclk),

    .probe0(current_fsm_state), // FSM
    .probe1(Pselx),
    .probe2(Penable),
    .probe3(Pwrite),
    .probe4(Hclk),
    .probe5(valid),
    .probe6(Paddr),
    .probe7(transfer_data),
    .probe8(baud_tick)
);
     

    assign Prdata = (Pselx[0]) ? led_prdata :
                    (Pselx[1]) ? timer_prdata :
                    (Pselx[2]) ? uart_prdata :
                    32'd0;

    assign transfer_data = Pwrite ? Pwdata : Prdata;
    assign transfer_active = (Pselx != 3'b000);
    assign display_op_write = transfer_active ? Pwrite : last_op_write;
    assign display_peripheral = transfer_active ? Pselx : last_peripheral;
    assign display_data_byte = transfer_active ? transfer_data[7:0] : last_data_byte;

    assign LED = pattern_out;

    always @(posedge Hclk) begin
        if (reset_btn) begin
            last_op_write <= 1'b1;
            last_peripheral <= 3'b000;
            last_data_byte <= 8'h00;
        end
        else if (Pselx != 3'b000 && Penable) begin
            last_op_write <= Pwrite;
            last_peripheral <= Pselx;
            last_data_byte <= transfer_data[7:0];
        end
    end

endmodule
