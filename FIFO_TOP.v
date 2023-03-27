module FIFO_TOP (

    // Clocks and resets
    input wire          uart_clk,
    input wire          uart_rst,
    input wire          apb_clk,
    input wire          apb_rst,

    // RES FIFO
    input wire          res_read_en,
    input wire  [31:0]  res_write_data,
    input wire          res_write_en,
    output wire [31:0]  res_read_data_Q,  ///////
    output wire         res_empty_flg,
    output wire         res_full_flag,

    //RX FIFO
    input wire          rx_read_en,
    input wire  [55:0]  rx_write_data,
    input wire          rx_write_en,
    output wire [55:0]  rx_read_data_Q,  ////////
    output wire         rx_empty_flg,
    output wire         rx_full_flag,
    output wire [3:0]   rx_empty_locs,

    //TX FIFO
    input wire          tx_read_en,
    input wire  [55:0]  tx_write_data,
    input wire          tx_write_en,
    output wire [55:0]  tx_read_data_Q,  /////////
    output wire         tx_empty_flg,
    output wire         tx_full_flag,
    output wire [3:0]   tx_empty_locs
);

wire  [31:0]  res_read_data;     ////////
wire  [55:0]  rx_read_data;      ///////
wire  [55:0]  tx_read_data;      ///////

Res_fifo Res_fifo_FIFO (
    .wdata(res_write_data),
    .wen(res_write_en), 
    .ren(res_read_en),
    .rclk(uart_clk), 
    .wclk(apb_clk), 
    .r_reset(uart_rst), 
    .w_reset(apb_rst), 
    .rdata(res_read_data),
    .eflag(res_empty_flg), 
    .fflag(res_full_flag)
);


Two_IN_MUX Two_IN_MUX_RES (        /////////
    .IN0(res_read_data),
    .IN1('b0),
    .sel(res_empty_flg),
    .OUT(res_read_data_Q)
);


RX_fifo #(.WIDTH(56)) RX_fifo_FIFO (
    .wdataf(rx_write_data),
    .wenf(rx_write_en), 
    .renf(rx_read_en),
    .rclkf(apb_clk), 
    .wclkf(uart_clk), 
    .r_reset(apb_rst),
    .w_reset(uart_rst),
    .rdataf(rx_read_data),
    .eflagf(rx_empty_flg), 
    .fflagf(rx_full_flag),
    .emptyloctopf(rx_empty_locs)
);


Two_IN_MUX Two_IN_MUX_RX (        /////////
    .IN0(rx_read_data),
    .IN1('b0),
    .sel(rx_empty_flg),
    .OUT(rx_read_data_Q)
);


TX_fifo #(.WIDTH(56)) TX_fifo_FIFO (
    .wdataf(tx_write_data),
    .wenf(tx_write_en), 
    .renf(tx_read_en),
    .rclkf(uart_clk), 
    .wclkf(apb_clk),
    .r_reset(uart_rst), 
    .w_reset(apb_rst),
    .rdataf(tx_read_data),
    .eflagf(tx_empty_flg), 
    .fflagf(tx_full_flag),
    .emptyloctopf(tx_empty_locs)
);


Two_IN_MUX Two_IN_MUX_tx (        /////////
    .IN0(tx_read_data),
    .IN1('b0),
    .sel(tx_empty_flg),
    .OUT(tx_read_data_Q)
);

endmodule