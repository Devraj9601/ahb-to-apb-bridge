`timescale 1ns/1ps

module ahb_apb_tb;

reg Hclk;
reg Hresetn;

wire [3:0] LED;
wire tx;
wire [6:0] seg;
wire [3:0] an;

wire Hwrite_tb        = DUT.Hwrite_gen;
wire [1:0] Htrans_tb  = DUT.Htrans_gen;
wire [31:0] Haddr_tb  = DUT.Haddr_gen;
wire [31:0] Hwdata_tb = DUT.Hwdata_gen;
wire valid_tb         = DUT.valid;
wire [31:0] Haddr1_tb = DUT.Haddr1;
wire [31:0] Hwdata1_tb = DUT.Hwdata1;
wire Hwritereg_tb     = DUT.Hwritereg;
wire [3:0] state_tb   = DUT.current_fsm_state;
wire [2:0] Pselx_tb   = DUT.Pselx;
wire Penable_tb       = DUT.Penable;
wire Pwrite_tb        = DUT.Pwrite;
wire [31:0] Paddr_tb  = DUT.Paddr;
wire [31:0] Pwdata_tb = DUT.Pwdata;
wire [31:0] Prdata_tb = DUT.Prdata;
wire [31:0] transfer_data_tb = DUT.transfer_data;
wire baud_tick_tb     = DUT.baud_tick;
wire tick_tb          = DUT.tick;

Top DUT (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .LED(LED),
    .tx(tx),
    .seg(seg),
    .an(an)
);

initial Hclk = 0;
always #5 Hclk = ~Hclk;

initial begin
    $dumpfile("ahb_apb_tb.vcd");
    $dumpvars(0, ahb_apb_tb);

    Hresetn = 1;
    repeat(10) @(posedge Hclk);
    Hresetn = 0;

    wait (DUT.GEN.state == 6'd23);
    repeat(20) @(posedge Hclk);

     
end

// Shorten only the demonstration wait gaps for simulation visibility.
//always @(posedge Hclk) begin
 //   if (!Hresetn && DUT.GEN.delay_count > 26'd50)
 //       DUT.GEN.delay_count <= 26'd20;
//end

endmodule
