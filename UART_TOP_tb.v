`timescale 1ms/1ns
module UART_TOP_TB();

// testbench intelnal signals
reg           clk_tb;
reg           rst_tb;
reg           sdata_rx_tb;
reg           part_en_uart_tb;
reg           part_type_uart_tb;
reg           err_inj_en_uart_tb;
reg  [1:0]    err_inj_type_tb;
reg           par_count_clr_uart_tb;
reg  [1:0]    clk_rate_tb;
reg           loop_uart_tb;
reg           full_to_rx_tb;
reg  [55:0]   preq_tb;
reg  [55:0]   pres_tb;
reg           data_vld_tx_tb;
reg           par_err_count_en_uart_tb;
reg           data_sel_tb;
wire          busy_tb;
wire          err_inj_done_uart_tb;
wire          sdata_tx_tb;
wire [15:0]   par_err_count_uart_tb;
wire          data_vld_rx_tb;
wire [55:0]   pdata_out_tb;

// testbench parameters 
localparam clk_period = 0.001;

// clock generation 
always # (clk_period /2) clk_tb = ~clk_tb;

// module instatiation
UART_TOP UART_TOP_tb(
   .clk(clk_tb),
   .rst(rst_tb),
   .sdata_rx(sdata_rx_tb),
   .part_en_uart(part_en_uart_tb),
   .part_type_uart(part_type_uart_tb),
   .err_inj_en_uart(err_inj_en_uart_tb),
   .err_inj_type(err_inj_type_tb),
   .par_count_clr_uart(par_count_clr_uart_tb),
   .clk_rate(clk_rate_tb),
   .loop_uart(loop_uart_tb),
   .full_to_rx(full_to_rx_tb),
   .preq(preq_tb),
   .pres(pres_tb),
   .data_vld_tx(data_vld_tx_tb),
   .par_err_count_en_uart(par_err_count_en_uart_tb),
   .data_sel(data_sel_tb),
   .busy(busy_tb),
   .err_inj_done_uart(err_inj_done_uart_tb),
   .sdata_tx(sdata_tx_tb),
   .par_err_count_uart(par_err_count_uart_tb),
   .data_vld_rx(data_vld_rx_tb),
   .pdata_out(pdata_out_tb) 
);

// main intial block
initial 
 begin

     // intialization 
     clk_tb= 1'b1;
     rst_tb= 1'b1;
     sdata_rx_tb = 56'H02FFFF00000000;
     part_en_uart_tb = 1'b1;
     part_type_uart_tb = 1'b0;
     err_inj_en_uart_tb = 1'b0;
     err_inj_type_tb = 2'b00;
     par_count_clr_uart_tb = 1'b0;
     clk_rate_tb = 2'b10;
     loop_uart_tb = 1'b1;
     full_to_rx_tb = 1'b0;
     preq_tb = 56'H03FFFF00000000;
     pres_tb = 56'H040000FFFFFFFF;
     data_vld_tx_tb = 1'b0;
     par_err_count_en_uart_tb = 1'b1;
     data_sel_tb = 1'b0;

     // Reset
     #(clk_period * 0.2*8)
     rst_tb = 1'b0;
     #(clk_period * 0.6*8)
     rst_tb = 1'b1;
      
     
     // test case
     #(clk_period * 0.2*8) 
     data_vld_tx_tb = 1'b1;
     #(clk_period *10)
     data_vld_tx_tb = 1'b0;

    #(clk_period*100*16)

/*
     #(clk_period) 
     $display ("-------------------test RREQ CASE--------------------");
     if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

        
      #(clk_period*8) 
    $display ("-------------------Start bit--------------------");
     if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     
     DataVLD_tb = 1'b0;
      
    #(clk_period*8) 
    $display ("-------------------first data bit--------------------");
     if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     

     #(clk_period*7*8 ) 
    $display ("-------------------last data bit--------------------");
     if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
    

    #(clk_period*8) 
    $display ("-------------------parity bit--------------------");
    if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");


    #(clk_period*8) 
    $display ("-------------------stop bit--------------------");
    if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

    #(clk_period*25*8) 
    $display ("-------------------END of Data--------------------");
    if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b1 & BUSY_tb==1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled"); 


     #(clk_period*100*8)

/*
     #(clk_period*10)


     PREQ_tb = 56'H02FFFF00000000;
     PRES_tb = 56'H040000FFFFFFFF;
     DataVLD_tb = 1'b1;
     Err_inj_type_tb = 2'b00;
     Err_inj_EN_tb = 1'b1;

     #(clk_period) 
      DataVLD_tb = 1'b0;
     $display ("-------------------test WREQ CASE--------------------");
     if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

        
      #(clk_period) 
    $display ("-------------------Start bit--------------------");
     if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     
    
      
    #(clk_period) 
    $display ("-------------------first data bit--------------------");
     if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     

     #(clk_period*7 ) 
    $display ("-------------------last data bit--------------------");
     if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
    

    #(clk_period) 
    $display ("-------------------parity bit with CMD error--------------------");
    if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b0 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");


    #(clk_period) 
    $display ("-------------------stop bit--------------------");
    if (Err_inj_Done_tb==1'b1 & SData_Tx_tb==1'b1 & BUSY_tb==1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

    #(clk_period*68) 
    $display ("-------------------END of Data--------------------");
    if (Err_inj_Done_tb==1'b0 & SData_Tx_tb==1'b1 & BUSY_tb==1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled"); 
    */
    
     $stop; // $finish;(will close modelsim)
     
 end



endmodule 