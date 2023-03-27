module UART_RX(
    input  wire           par_en,
    input  wire           uart_clk,
    input  wire           rst,
    input  wire           sdata,
    input  wire           full,
    input  wire           par_count_clr,
    input  wire           par_err_count_en,
    input  wire           par_type,
    input  wire           tx_clk_en,
    input  wire  [1:0]    clk_rate,
    output wire  [55:0]   pdata,
    output wire  [15:0]   par_err_count,
    output wire           data_vld
);

wire       edge_done_top;
wire       edge_done_m2_top;
wire [3:0] bit_count_top;
wire       par_err_top;
wire       str_err_top;
wire       stp_err_top;
wire       samp_en_top;
wire       bit_count_en_top;
wire       edge_count_en_top;
wire       par_chk_en_top;
wire       str_chk_en_top;
wire       stp_chk_en_top;
wire       deser_en_top;
wire       data_valid_top;
wire [4:0] edge_count_top;
wire [5:0] scale_top;
wire       samp_out_top;
wire [7:0] pdata_top;

Frame_FSM Frame_FSM_top(
    .clk(uart_clk),   
    .rst(rst),  
    .sdata(sdata),
    .par_en(par_en),
    .edge_done(edge_done_top),
    .edge_done_m2(edge_done_m2_top),
    .bit_count(bit_count_top),
    .par_err(par_err_top),
    .str_err(str_err_top),
    .stp_err(stp_err_top),
    .samp_en(samp_en_top),
    .bit_count_en(bit_count_en_top),
    .edge_count_en(edge_count_en_top),
    .par_chk_en(par_chk_en_top),
    .str_chk_en(str_chk_en_top),
    .stp_chk_en(stp_chk_en_top),
    .deser_en(deser_en_top),   
    .data_valid(data_valid_top)
);

Bit_Counter  Bit_Counter_top (
    .clk(uart_clk),
    .rst(rst),
    .en(bit_count_en_top),
    .par_en(par_en),
    .edge_done(edge_done_top),
    .bit_count(bit_count_top)   
);

Edge_Counter Edge_Counter_top (
    .clk(uart_clk),
    .rst(rst),
    .en(edge_count_en_top),
    .scale(scale_top),
    .edge_done(edge_done_top),
    .edge_done_m2(edge_done_m2_top), 
    .edge_count(edge_count_top)
);

RX_TX_Scale RX_TX_Scale_top (
    .tx_rate(clk_rate),
    .scale(scale_top)
);

DeSerializer DeSerializer_top(
    .clk(uart_clk),
    .rst(rst),
    .en(deser_en_top),   
    .samp_out(samp_out_top),
    .edge_done(edge_done_top),
    .pdata(pdata_top) 
);

Sampling Sampling_top(
    .clk(uart_clk),
    .rst(rst),
    .sdata(sdata),
    .samp_en(samp_en_top),
    .edge_count(edge_count_top),
    .scale(scale_top),
    .samp_out(samp_out_top)
);

Par_Check Par_Check_top (
    .clk(uart_clk),
    .rst(rst),
    .pdata(pdata_top),
    .samp_out(samp_out_top),
    .par_type(par_type),
    .en(par_chk_en_top),
    .par_err(par_err_top)
);

Par_err_Counter Par_err_Counter_top(
    .clk(uart_clk),
    .rst(rst),
    .clr(par_count_clr),
    .en(par_err_count_en),
    .edge_done(edge_done_top),
    .par_err(par_err_top),  
    .par_err_count(par_err_count)
);

Reg_Out Reg_Out_top (
    .data_in(pdata_top),
    .full(full),
    .clk(uart_clk),
    .rst(rst),
    .data_vld(data_valid_top),
    .tx_clock(edge_done_top),
    .out_data_vld(data_vld),
    .pdata(pdata)
);

Start_Check Start_Check_top(
    .clk(uart_clk),
    .rst(rst),
    .en(str_chk_en_top),
    .edge_done(edge_done_top),
    .samp_out(samp_out_top),
    .start_err(str_err_top)
);

Stop_Check Stop_Check_top (
    .clk(uart_clk),
    .rst(rst),
    .en(stp_chk_en_top),
    .samp_out(samp_out_top),
    .stop_err(stp_err_top)
);

endmodule 
