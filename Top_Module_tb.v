`timescale 1ns/1ps
module Top_Module_tb();

// testbench intelnal signals
 reg            sdata_rx_tb;
 reg            clk_uart_tb;
 reg            rst_uart_tb;
 reg            clk_apb_tb;
 reg            rst_apb_tb;
 reg            ready_master_tb;
 reg  [31:0]    read_data_master_tb;
 reg  [31:0]    write_data_slave_tb;
 reg  [15:0]    addr_to_slave_tb;
 reg            en_to_slave_tb;
 reg            write_sig_slave_tb;
 reg            sel_sig_slave_tb;
 wire           sdata_tx_tb;
 wire  [31:0]   write_data_master_tb;
 wire  [15:0]   addr_from_master_tb;
 wire           en_from_master_tb;
 wire           write_sig_master_tb;
 wire           sel_sig_master_tb;      
 wire           ready_slave_tb;
 wire  [31:0]   read_data_slave_tb;

// testbench parameters 
localparam clk_period_uart = 31.25;
localparam clk_period_apb = 38.46;

// clock generation 
always # (clk_period_uart /2) clk_uart_tb = ~clk_uart_tb;
always # (clk_period_apb /2)  clk_apb_tb = ~clk_apb_tb;

// module instatiation
Top_Module Top_Module_tb(
   .sdata_rx(sdata_rx_tb),
   .clk_uart(clk_uart_tb),
   .rst_uart(rst_uart_tb),
   .clk_apb(clk_apb_tb),
   .rst_apb(rst_apb_tb),
   .ready_master(ready_master_tb),
   .read_data_master(read_data_master_tb),
   .write_data_slave(write_data_slave_tb),
   .addr_to_slave(addr_to_slave_tb),
   .en_to_slave(en_to_slave_tb),
   .write_sig_slave(write_sig_slave_tb),
   .sel_sig_slave(sel_sig_slave_tb),
   .sdata_tx(sdata_tx_tb),
   .write_data_master(write_data_master_tb),
   .addr_from_master(addr_from_master_tb),
   .en_from_master(en_from_master_tb),
   .write_sig_master(write_sig_master_tb),
   .sel_sig_master(sel_sig_master_tb),     
   .ready_slave(ready_slave_tb),
   .read_data_slave(read_data_slave_tb)
);

// main intial block
initial 
 begin

     // intialization 

     sdata_rx_tb             = 56'H02FFFF00000000 ;
     clk_uart_tb             = 1'b1 ;
     rst_uart_tb             = 1'b1 ;
     clk_apb_tb              = 1'b1 ;
     rst_apb_tb              = 1'b1 ;
     ready_master_tb         = 1'b0 ;
     read_data_master_tb     = 32'H0000000;   //response
     write_data_slave_tb     = 32'H0000000 ;   // read request
     addr_to_slave_tb        = 16'H0000 ;       // request address
     en_to_slave_tb          = 1'b0 ;
     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b0 ;


     // Reset
     #(clk_period_apb * 0.2)
     rst_uart_tb = 1'b0;
     rst_apb_tb = 1'b0;

     #(clk_period_apb * 0.6)
     rst_uart_tb = 1'b1;
     rst_apb_tb = 1'b1;
     #(clk_period_apb * 0.2)


// test case
     #(clk_period_apb*2)
     ready_master_tb         = 1'b1;
     read_data_master_tb     = 32'H00000000;   //response
     write_data_slave_tb     = 32'Haaaaaaaa;   // read request
     addr_to_slave_tb        = 16'Hbbbb;       // request address

     write_sig_slave_tb      = 1'b1 ;
     sel_sig_slave_tb        = 1'b1 ;

     #(clk_period_apb)
      en_to_slave_tb         = 1'b1; 

    #(clk_period_apb)  
     ready_master_tb         = 1'b0;
     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b0 ;
     en_to_slave_tb         = 1'b0;    
    #(clk_period_apb*700)

     $display ("-------------------test CASE 1 WREQ--------------------");
     if (write_data_master_tb ==32'Haaaaaaaa & addr_from_master_tb == 16'Hbbbb & read_data_slave_tb == 32'H00000000 &en_from_master_tb == 1'b1 & write_sig_master_tb == 1'b1 & sel_sig_master_tb == 1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

     #(clk_period_apb*2)
     ready_master_tb         = 1'b1;
     read_data_master_tb     = 32'H00000000;   //response
     write_data_slave_tb     = 32'H00000000;   // read request
     addr_to_slave_tb        = 16'Hbbbb;       // request address

     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b1 ;

     #(clk_period_apb)
      en_to_slave_tb         = 1'b1; 

    #(clk_period_apb)  
     ready_master_tb         = 1'b0;
     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b0 ;
     en_to_slave_tb          = 1'b0;    
    #(clk_period_apb*700)

     $display ("-------------------test CASE 2 RREQ--------------------");
     if (write_data_master_tb ==32'H00000000 & addr_from_master_tb == 16'Hbbbb & read_data_slave_tb == 32'H00000000 &en_from_master_tb == 1'b1 & write_sig_master_tb == 1'b0 & sel_sig_master_tb == 1'b1)
     $display ("test case 2 : passed");
     else 
     $display ("test case 2 : failled");


     #(clk_period_apb*2)
     ready_master_tb         = 1'b1;
     read_data_master_tb     = 32'HCCCCCCCC;   //response
     write_data_slave_tb     = 32'H00000000;   // read request
     addr_to_slave_tb        = 16'H0000;       // request address

     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b1 ;

     #(clk_period_apb)
      en_to_slave_tb         = 1'b1; 

     #(clk_period_apb) 
       ready_master_tb         = 1'b0;
    #(clk_period_apb*550)


     $display ("-------------------test CASE 3 RRES--------------------");
     if (write_data_master_tb ==32'H00000000 & addr_from_master_tb == 16'H0000 & read_data_slave_tb == 32'HCCCCCCCC & en_from_master_tb == 1'b0 & write_sig_master_tb == 1'b0 & sel_sig_master_tb == 1'b0)
     $display ("test case 3 : passed");
     else 
     $display ("test case 3 : failled");
   
       write_sig_slave_tb      = 1'b0 ;
       sel_sig_slave_tb        = 1'b0 ;
       en_to_slave_tb          = 1'b0 ; 


     #(clk_period_apb*2)
     ready_master_tb         = 1'b1;
     read_data_master_tb     = 32'H00000000;   //response
     write_data_slave_tb     = 32'H00000000;   // read request
     addr_to_slave_tb        = 16'H1212;       // request address

     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b1 ;

     #(clk_period_apb)
      en_to_slave_tb         = 1'b1; 

    #(clk_period_apb)  
     ready_master_tb         = 1'b0;
     write_sig_slave_tb      = 1'b0 ;
     sel_sig_slave_tb        = 1'b0 ;
     en_to_slave_tb          = 1'b0;    
    #(clk_period_apb*700)

     $display ("-------------------test CASE 4 RREQ--------------------");
     if (write_data_master_tb ==32'H00000000 & addr_from_master_tb == 16'H1212 & read_data_slave_tb == 32'H00000000 &en_from_master_tb == 1'b1 & write_sig_master_tb == 1'b0 & sel_sig_master_tb == 1'b1)
     $display ("test case 2 : passed");
     else 
     $display ("test case 2 : failled");


     #(clk_period_apb*2)
     ready_master_tb         = 1'b1;
     read_data_master_tb     = 32'Heeeeeeee;   //response
     write_data_slave_tb     = 32'H55555555;   // read request
     addr_to_slave_tb        = 16'Hdddd;       // request address

      write_sig_slave_tb      = 1'b1 ;
     sel_sig_slave_tb        = 1'b1 ;

     #(clk_period_apb)
      en_to_slave_tb         = 1'b1; 

     #(clk_period_apb) 
       write_sig_slave_tb      = 1'b0 ;
       ready_master_tb         = 1'b0;
    #(clk_period_apb*550)

     $display ("-------------------test CASE 5 RRES & WREQ--------------------");
     if (write_data_master_tb ==32'H00000000 & addr_from_master_tb == 16'H0000 & read_data_slave_tb == 32'Heeeeeeee & en_from_master_tb == 1'b0 & write_sig_master_tb == 1'b0 & sel_sig_master_tb == 1'b0)
     $display ("test case 5 : passed");
     else 
     $display ("test case 5 : failled"); 

    #(clk_period_apb)  
      write_sig_slave_tb      = 1'b0;
      sel_sig_slave_tb        = 1'b0;
      en_to_slave_tb          = 1'b0;  

    #(clk_period_apb*600)     
     write_sig_slave_tb      = 1'b1 ;
     sel_sig_slave_tb        = 1'b1 ;
     en_to_slave_tb          = 1'b1;    
    #(clk_period_apb)
      ready_master_tb         = 1'b0;
      write_sig_slave_tb      = 1'b0;
      sel_sig_slave_tb        = 1'b0;
      en_to_slave_tb          = 1'b0; 

    #(clk_period_apb*200) 
    
     $display ("-------------------test CASE 6 RRES & WREQ--------------------");
     if (write_data_master_tb ==32'H55555555 & addr_from_master_tb == 16'Hdddd & read_data_slave_tb == 32'H00000000 & en_from_master_tb == 1'b1 & write_sig_master_tb == 1'b1 & sel_sig_master_tb == 1'b1)
     $display ("test case 6 : passed");
     else 
     $display ("test case 6 : failled"); 

    #(clk_period_uart*5)


    
     $stop;
     
 end



endmodule 