module REG_FILE #(parameter Data_Width = 32, parameter Add_Width = 16)
 (
    input  wire [Data_Width-1:0] WrData,
    input  wire [Add_Width-1:0]  Address,
    input  wire                  WrEn,
    input  wire                  RdEn,
    input  wire                  CLK,
    input  wire                  RST,
    input  wire [15:0]           ParErrCount, 
    input  wire                  ErrInjDone,
    input  wire [3:0]            tx_FifoEmptyLoc, 
    input  wire [3:0]            rx_FifoEmptyLoc, 
    output reg  [1:0]            TxClk,
    output reg                   ParErrEn,
    output reg                   ParErrclr,
    output reg                   ErrInjEn,
    output reg  [1:0]            ErrInjType, 
    output reg                   ParEn,
    output reg                   par_type,
    output reg                   LoopBack,
    output reg  [Data_Width-1:0] RdData
);  

localparam depth_width = 2**Add_Width;
reg [7:0] REG [depth_width-1:0];
integer i;

always @(posedge CLK, negedge RST) 
begin
    if (!RST)
    begin
        RdData <= 'b0;
        for(i=0; i<16'HFFDF; i=i+1)
        begin
            REG [i] <= 8'b0;
        end
        REG[16'HFFE0] <= 8'b10110000;         
        REG[16'HFFE1] <= 8'b00000000;
        REG[16'HFFE2] <= 8'b00000000;
        REG[16'HFFE3] <= 8'b00000000;
        REG[16'HFFE4] <= 8'b00000000;
    end 

    else if (RdEn)
    begin
       RdData[7:0] <= REG[Address<<2];
       RdData[15:8] <= REG[(Address<<2)+16'd1];
       RdData[23:16] <= REG[(Address<<2)+16'd2];
       RdData[31:24] <= REG[(Address<<2)+16'd3];
    end 

    else if (WrEn)
    begin
        REG[Address<<2] <= WrData[7:0];
        REG[(Address<<2)+16'd1] <= WrData[15:8];
        REG[(Address<<2)+16'd2] <= WrData[23:16];
        REG[(Address<<2)+16'd3] <= WrData[31:24];
    end
   
end

always @(*) begin
  TxClk = REG[16'HFFE0][7:6]; 
  ParEn = REG[16'HFFE0][5];
  LoopBack = REG[16'HFFE0][4];
  ParErrEn = REG[16'HFFE0][3]; 
  ParErrclr = REG[16'HFFE0][2]; 
  ErrInjEn = REG[16'HFFE0][1];
  par_type = REG[16'HFFE0][0];
  REG[16'HFFE1][7:0] = ParErrCount[7:0];
  REG[16'HFFE2][7:0] = ParErrCount[15:8];
  REG[16'HFFE3][7:4] = rx_FifoEmptyLoc;
  REG[16'HFFE3][3:0] = tx_FifoEmptyLoc;
  ErrInjType = REG[16'HFFE4][7:6]; 
  REG[16'HFFE4][5] = ErrInjDone;

    
end
  
endmodule