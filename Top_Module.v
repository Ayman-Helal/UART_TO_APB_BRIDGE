module Top_Module (
    input  wire           sdata_rx,
    input  wire           clk_uart,
    input  wire           rst_uart,
    input  wire           clk_apb,
    input  wire           rst_apb,
    input  wire           ready_master,
    input  wire  [31:0]   read_data_master,
    input  wire  [31:0]   write_data_slave,
    input  wire  [15:0]   addr_to_slave,
    input  wire           en_to_slave,
    input  wire           write_sig_slave,
    input  wire           sel_sig_slave,
    output wire           sdata_tx,
    output wire  [31:0]   write_data_master,
    output wire  [15:0]   addr_from_master,
    output wire           en_from_master,
    output wire           write_sig_master,
    output wire           sel_sig_master,           
    output wire           ready_slave,
    output wire  [31:0]   read_data_slave
);

wire         part_en_uart_top;
wire         part_en_apb_top;

wire         part_type_uart_top;
wire         part_type_apb_top;

wire         err_inj_en_uart_top;
wire         err_inj_en_apb_top;

wire         par_count_clr_uart_top;
wire         par_count_clr_apb_top;

wire         loop_uart_top;
wire         loop_apb_top;

wire         par_err_count_en_uart_top;
wire         par_err_count_en_apb_top;

wire         err_inj_done_uart_top;
wire         err_inj_done_apb_top;

wire  [15:0] par_err_count_uart_top;
wire  [15:0] par_err_count_apb_top;
wire  [15:0] count_gray;
wire  [15:0] count_gray_synch;

wire  [1:0]  err_inj_type_top;
wire  [1:0]  clk_rate_top;
wire         full_to_rx_top;
wire  [55:0] preq_top;
wire  [31:0] pres_top;
wire         data_vld_tx_top;
wire         data_sel_top;
wire         busy_top;
wire         data_vld_rx_top;
wire  [55:0] pdata_out_top;

wire [31:0]  WrData_reg;
wire [15:0]  Address_reg;
wire [31:0]  RdData_reg;
wire         WrEn_reg;
wire         RdEn_reg;
wire [3:0]   tx_FifoEmptyLoc_reg;
wire [3:0]   rx_FifoEmptyLoc_reg;

wire  [31:0] res_write_data_top;
wire         res_write_en_top;
wire         res_empty_flg_top;
wire         res_full_flag_top;

wire         rx_read_en_top;
wire  [55:0] rx_read_data_top;
wire         rx_empty_flg_top;

wire  [55:0] tx_write_data_top;
wire         tx_write_en_top;
wire         tx_empty_flg_top;
wire         tx_full_flag_top;

wire         REN_from_uart_to_fifo;
wire         REN_tx_top;
wire         REN_res_top;

wire [31:0]  read_res_top;
wire [15:0]  req_addr_top;
wire [31:0]  req_data;
wire         wr_to_apb;
wire [47:0]  write_read_req_from_apb;
wire         wr_sig_from_apb;
wire         slave_en_top;
wire         en_sig_from_dec;
wire         en_sig_res_dec;


//////UART/////////////////////// 


assign data_sel_top = !res_empty_flg_top;
assign REN_from_uart_to_tx_fifo = REN_tx_top &(~busy_top);
assign REN_from_uart_to_res_fifo = REN_res_top &(~busy_top);

UART_TOP UART_TOP_MOD (
    .clk(clk_uart),
    .rst(rst_uart),
    .sdata_rx(sdata_rx),
    .part_en_uart(part_en_uart_top),
    .part_type_uart(part_type_uart_top),
    .err_inj_en_uart(err_inj_en_uart_top),
    .err_inj_type(err_inj_type_top),
    .par_count_clr_uart(par_count_clr_uart_top),
    .clk_rate(clk_rate_top),
    .loop_uart(loop_uart_top),
    .full_to_rx(full_to_rx_top),
    .preq(preq_top),
    .pres({8'H04,pres_top,16'b0}),
    .data_vld_tx_tx(!tx_empty_flg_top),
    .data_vld_tx_res(!res_empty_flg_top),
    .par_err_count_en_uart(par_err_count_en_uart_top),
    .data_sel(data_sel_top),
    .busy(busy_top),
    .err_inj_done_uart(err_inj_done_uart_top),
    .sdata_tx(sdata_tx),
    .par_err_count_uart(par_err_count_uart_top),
    .data_vld_rx(data_vld_rx_top),
    .REN_tx(REN_tx_top),
    .REN_res(REN_res_top),
    .pdata_out(pdata_out_top)
);



/////synchronization////////////////////////

Bit_synch Bit_synch_top1 (
    .data_in(part_en_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(part_en_uart_top)
);

Bit_synch Bit_synch_top2 (
    .data_in(part_type_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(part_type_uart_top)
);

Bit_synch Bit_synch_top3 (
    .data_in(err_inj_en_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(err_inj_en_uart_top)
);

Bit_synch Bit_synch_top4 (
    .data_in(par_count_clr_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(par_count_clr_uart_top)
);

Bit_synch_loop Bit_synch_top5 (
    .data_in(loop_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(loop_uart_top)
);

Bit_synch Bit_synch_top6 (
    .data_in(par_err_count_en_apb_top),
    .clk(clk_uart),
    .rst(rst_uart),
    .synch_data(par_err_count_en_uart_top)
);

Bit_synch Bit_synch_top7 (
    .data_in(err_inj_done_uart_top),
    .clk(clk_apb),
    .rst(rst_apb),
    .synch_data(err_inj_done_apb_top)
);

// error count synchronization

BtoG_MOD  BtoG_top (
    .clk(clk_uart),
    .rst(rst_uart),
    .data_in(par_err_count_uart_top),
    .data_out(count_gray)
);

Bus_Synch Bus_Synch_top (
    .data_in(count_gray),
    .clk(clk_apb),
    .rst(rst_apb),
    .synch_data(count_gray_synch)
);

GtoB_MOD  GtoB_top (
    .din(count_gray_synch),
    .dout(par_err_count_apb_top)
);


//////REG FILE/////////////////////////////

REG_FILE REG_FILE_MOD (
    .WrData(WrData_reg),
    .Address(Address_reg),
    .WrEn(WrEn_reg),
    .RdEn(RdEn_reg),
    .CLK(clk_apb),
    .RST(rst_apb),
    .ParErrCount(par_err_count_apb_top), 
    .ErrInjDone(err_inj_done_apb_top),
    .tx_FifoEmptyLoc(tx_FifoEmptyLoc_reg),
    .rx_FifoEmptyLoc(rx_FifoEmptyLoc_reg),
    .TxClk(clk_rate_top),
    .ParErrEn(par_err_count_en_apb_top),
    .ParErrclr(par_count_clr_apb_top),
    .ErrInjEn(err_inj_en_apb_top),
    .ErrInjType(err_inj_type_top), 
    .ParEn(part_en_apb_top),
    .par_type(part_type_apb_top),
    .LoopBack(loop_apb_top),
    .RdData(RdData_reg)
);


/////FIFO///////////////////////////////////////


FIFO_TOP FIFO_TOP_MOD (
    .uart_clk(clk_uart),
    .uart_rst(rst_uart),
    .apb_clk(clk_apb),
    .apb_rst(rst_apb),

    .res_read_en(REN_from_uart_to_res_fifo),
    .res_write_data(res_write_data_top),
    .res_write_en(res_write_en_top),
    .res_read_data(pres_top),
    .res_empty_flg(res_empty_flg_top),
    .res_full_flag(res_full_flag_top),

    .rx_read_en(rx_read_en_top),
    .rx_write_data(pdata_out_top),
    .rx_write_en(data_vld_rx_top),
    .rx_read_data(rx_read_data_top),
    .rx_empty_flg(rx_empty_flg_top),
    .rx_full_flag(full_to_rx_top),
    .rx_empty_locs(rx_FifoEmptyLoc_reg),

    .tx_read_en(REN_from_uart_to_tx_fifo),
    .tx_write_data(tx_write_data_top),
    .tx_write_en(tx_write_en_top),
    .tx_read_data(preq_top),
    .tx_empty_flg(tx_empty_flg_top),
    .tx_full_flag(tx_full_flag_top),
    .tx_empty_locs(tx_FifoEmptyLoc_reg)
);

////Decoder and Encoder//////////////////////////////////////////////////

Decoder Decoder_MOD (
    .data_in(rx_read_data_top),
    .en(!rx_empty_flg_top),
    .clk(clk_apb),
    .rst(rst_apb),
    .master_en(en_sig_from_dec),
    .slave_en(en_sig_res_dec),
    .REN(rx_read_en_top),
    .read_res(read_res_top),
    .req_addr(req_addr_top),
    .req_data(req_data),
    .wr(wr_to_apb)
);


Encoder Encoder_MOD (
    .write_read_req(write_read_req_from_apb),
    .wr(wr_sig_from_apb),
    .write_read_cmd(tx_write_data_top)
);


/////APB //////////////////////////////////////////////////////////////



topapb topapb_MOD (
    .apb_clk(clk_apb),
    .reset(rst_apb),
    .ready_m(ready_master),
    .rdata_m(read_data_master),
    .wdata_s(write_data_slave),
    .outaddr_s(addr_to_slave),
    .en_s(en_to_slave),
    .write_s(write_sig_slave),
    .dec_en_m(en_sig_from_dec),
    .en_rres_s(en_sig_res_dec),
    .sel_s(sel_sig_slave),
    .wait_mfifo(res_full_flag_top),
    .daddr_mdec(req_addr_top),
    .wr_mdec(wr_to_apb),
    .wdata_mdec(req_data),
    .regreaddata_s(RdData_reg),
    .rres_sdec(read_res_top), 
    .wait_sfifo(tx_full_flag_top),

    .regwritedata_s(WrData_reg),
    .regaddr_s(Address_reg),
    .wrreq_s(write_read_req_from_apb),
    .wr_senc(wr_sig_from_apb),         
    .wen_sfifo(tx_write_en_top),
    .ready_s(ready_slave),
    .rdata_s(read_data_slave),
    .wdata_m(write_data_master),
    .outaddr_m(addr_from_master),
    .en_m(en_from_master),
    .write_m(write_sig_master),
    .sel_m(sel_sig_master),
    .wdata_mfifo(res_write_data_top),
    .wen_mfifo(res_write_en_top),
    .wenreg_s(WrEn_reg),
    .renreg_s(RdEn_reg) 
);

endmodule 
