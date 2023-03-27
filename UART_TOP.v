module UART_TOP (
    input  wire          clk,
    input  wire          rst,
    input  wire          sdata_rx,
    input  wire          part_en_uart,
    input  wire          part_type_uart,
    input  wire          err_inj_en_uart,
    input  wire [1:0]    err_inj_type,
    input  wire          par_count_clr_uart,
    input  wire [1:0]    clk_rate,
    input  wire          loop_uart,
    input  wire          full_to_rx,
    input  wire [55:0]   preq,
    input  wire [55:0]   pres,
    input  wire          data_vld_tx_tx,
    input  wire          data_vld_tx_res,
    input  wire          par_err_count_en_uart,
    input  wire          data_sel,
    output wire          busy,
    output wire          err_inj_done_uart,
    output wire          sdata_tx,
    output wire [15:0]   par_err_count_uart,
    output wire          data_vld_rx,
    output wire          REN_tx,
    output wire          REN_res,
    output wire [55:0]   pdata_out
);

wire         tx_en_top;
wire         rx_in;
wire         sdata_rx_syn;



UART_TX UART_TX_UART (
    .CLK(clk),
    .RST(rst),
    .ParType(part_type_uart),
    .ParEN(part_en_uart),
    .tx_en(tx_en_top),    
    .PREQ(preq),
    .PRES(pres),
    .Err_inj_type(err_inj_type),
    .Err_inj_EN(err_inj_en_uart),
    .DataVLD_tx(data_vld_tx_tx),
    .DataVLD_res(data_vld_tx_res),
    .Err_inj_Done(err_inj_done_uart),
    .SData_Tx(sdata_tx),
    .REN_tx(REN_tx),
    .REN_res(REN_res),
    .BUSY(busy)   
);


Clk_Div Clk_Div_UART (
    .clk(clk),
    .rst(rst),
    .clk_rate(clk_rate),
    .tx_en(tx_en_top)
);

Bit_synch_loop Bit_synch_top (
    .data_in(sdata_rx),
    .clk(clk),
    .rst(rst),
    .synch_data(sdata_rx_syn)
);


Two_IN_MUX #(.width(1)) Two_IN_MUX_UART (
    .IN0(sdata_rx_syn),
    .IN1(sdata_tx),
    .sel(loop_uart),
    .OUT(rx_in)
);

UART_RX UART_RX_UART (
    .par_en(part_en_uart),
    .uart_clk(clk),
    .rst(rst),
    .sdata(rx_in),
    .full(full_to_rx),
    .par_count_clr(par_count_clr_uart),
    .par_err_count_en(par_err_count_en_uart),
    .par_type(part_type_uart),
    .tx_clk_en(tx_en_top),
    .clk_rate(clk_rate),
    .pdata(pdata_out),
    .par_err_count(par_err_count_uart),
    .data_vld(data_vld_rx)
);


endmodule