module tx_top (
    input wire          CLK,
    input wire          RST,
    input wire          ParType,
    input wire          ParEN,
    input wire          DataSel,
    input wire  [1:0]   clk_rate,
    input wire  [55:0]  PREQ,
    input wire  [55:0]  PRES,
    input wire  [1:0]   Err_inj_type,
    input wire          Err_inj_EN,
    input wire          DataVLD,
    output wire         Err_inj_Done,
    output wire         SData_Tx,
    output wire         BUSY   

);

wire tx_en_top;

Clk_Div Clk_Div_top (
    .clk(CLK),
    .rst(RST),
    .clk_rate(clk_rate),
    .tx_en(tx_en_top)
);

UART_TX UART_TX_top (
    .CLK(CLK),
    .RST(RST),
    .ParType(ParType),
    .ParEN(ParEN),
    .DataSel(DataSel),
    .PREQ(PREQ),
    .tx_en(tx_en_top),
    .PRES(PRES),
    .Err_inj_type(Err_inj_type),
    .Err_inj_EN(Err_inj_EN),
    .DataVLD(DataVLD),
    .Err_inj_Done(Err_inj_Done),
    .SData_Tx(SData_Tx),
    .BUSY(BUSY)   
);

endmodule