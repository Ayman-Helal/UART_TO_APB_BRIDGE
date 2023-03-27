module UART_TX (
    input wire          CLK,
    input wire          RST,
    input wire          ParType,
    input wire          ParEN,
   // input wire          DataSel,
    input wire          tx_en,    
    input wire  [55:0]  PREQ,
    input wire  [55:0]  PRES,
    input wire  [1:0]   Err_inj_type,
    input wire          Err_inj_EN,
    input wire          DataVLD_tx,
    input wire          DataVLD_res,
    output wire         Err_inj_Done,
    output wire         SData_Tx,
    output wire         REN_tx,
    output wire         REN_res,
    output wire         BUSY   
);

wire [55:0] PData_top;
wire        CMDErr_top;
wire        ADDErr_top;
wire        DataErr_top;
wire [2:0]  count_top;
wire        Bit_Done_top;
wire [7:0]  OutData_top;
wire        ENBI_top;
wire        ENBY_top;
wire        DBUSY_top;
wire        BYCRST_top; 
wire        Err_top;
wire        parityBit_top;
wire        Ser_EN_top;
wire        Ser_Done_top;
wire        SData_top;
wire [1:0]  sel_top;
wire        ParON_top;
wire        FBUSY_top;
wire        DataVLD_farme_top;
wire        data_sel_top;
wire        ffp_en;

parameter stop = 1'b1;
parameter start = 1'b0;

assign BUSY = DBUSY_top | FBUSY_top;



Two_IN_MUX Two_IN_MUX_TOP (
    .IN0(PREQ),
    .IN1(PRES),
    .sel(data_sel_top),
    .OUT(PData_top)
);

/*ffp ffp_TOP (
    .clk(CLK),
    .rst(RST),
    .en(!BUSY),
    .in(DataSel),
    .out(DataSel_reg)
);

Sel_FSM Sel_FSM_TOP (
    .clk(CLK),
    .rst(RST),
    .vld(DataVLD_res),
    .tx_en(tx_en),
    .count(count_top),
    .sel(DataSel_reg)

);  */


Error_Decoder Error_Decoder_TOP (
    .Err_type(Err_inj_type),
    .Err_En(Err_inj_EN),
    .CMDErr( CMDErr_top),
    .ADDErr( ADDErr_top),
    .DataErr(DataErr_top)
);

Data_FSM_MOD Data_FSM_TOP (
    .CLK(CLK),
    .RST(RST),
    .tx_en(tx_en),
    .PData(PData_top),
    .count(count_top),
    .CMDErr(CMDErr_top),
    .ADDErr(ADDErr_top),
    .DataErr(DataErr_top),
    .Data_VLD_tx(DataVLD_tx),
    .Data_VLD_res(DataVLD_res),
    .DataVLD_farme(DataVLD_farme_top),
    .sel(data_sel_top),
    .CMD(PData_top[50:48]),
    .Bit_done(Bit_Done_top),
    .OutData(OutData_top),
    .ENBI(ENBI_top),
    .ENBY(ENBY_top),
    .DBUSY(DBUSY_top),
    .FBUSY(FBUSY_top),
    .BYCRST(BYCRST_top),
    .REN_tx(REN_tx),
    .REN_res(REN_res),
    .Err(Err_top)    
);

Bit_counter_tx Bit_counter_TOP (
    .EN(ENBI_top),
    .ParEN(ParEN),
    .CLK(CLK),
    .RST(RST),
    .tx_en(tx_en),
    .Done(Bit_Done_top)
);


Byte_counter_tx Byte_counter_TOP (
    .EN(ENBY_top),
    .CLK(CLK),
    .SRST(RST),
    .tx_en(tx_en),
    .BYCRST(BYCRST_top),
    .BitDone(Bit_Done_top),
    .counter_out(count_top)
);

Parity Parity_TOP(
    .CLK(CLK),
    .RST(RST),
    .tx_en(tx_en),
    .parity_enable(ParON_top),
    .parity_type(ParType),
    .Err(Err_top), 
    .DATA(OutData_top),
    .Err_done(Err_inj_Done),
    .parityBit(parityBit_top) 
);

serializer serializer_TOP (
    .CLK(CLK),
    .RST(RST),
    .tx_en(tx_en),
    .Data(OutData_top),
    .EN(Ser_EN_top),
    .Done(Ser_Done_top),
    .SData(SData_top)
);

Frame_FSM_tx Frame_FSM_TOP (
    .ParEN(ParEN),
    .CLK(CLK),
    .RST(RST),
    .tx_en(tx_en),
    .DataVLD(DataVLD_farme_top),
    .Ser_Done(Ser_Done_top),
    .sel(sel_top),
    .ParON(ParON_top),
    .SerEN(Ser_EN_top), 
    .FBUSY(FBUSY_top)  
);
    
Four_IN_MUX Four_IN_MUX_TOP(
    .IN0(stop),
    .IN1(start),
    .IN2(SData_top),
    .IN3(parityBit_top),
    .sel(sel_top),
    .OUT(SData_Tx) 
);   
endmodule