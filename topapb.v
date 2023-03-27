module topapb#(parameter WIDTH = 32,
parameter ADDRBITS = 16)
(
    input         apb_clk,
    input reset,
    input ready_m,
    input [WIDTH-1:0] rdata_m,
    input [WIDTH-1:0] wdata_s,
    input [ADDRBITS-1:0] outaddr_s,
    input en_s,
    input write_s,
    input sel_s,
    input en_rres_s,                    //interface
    input wait_mfifo,                  //interface
    input [ADDRBITS-1:0] daddr_mdec ,  //interface
    input wr_mdec,                     //interface
    input [WIDTH-1:0] wdata_mdec,      //interface
    input [WIDTH-1:0] regreaddata_s,      //interface
    input [WIDTH-1:0] rres_sdec,       //interface
    input wait_sfifo,                  //interface
    input dec_en_m,                   //interface
    output [WIDTH-1:0] regwritedata_s,     //interface
    output [ADDRBITS-1:0] regaddr_s,   //interface
    output [47:0] wrreq_s,             //interface
    output wr_senc,                    //interface
    output wen_sfifo,                  //interface
    output  ready_s,
    output  [WIDTH-1:0] rdata_s,
    output  [WIDTH-1:0] wdata_m,
    output  [ADDRBITS-1:0] outaddr_m,
    output  en_m,
    output  write_m,
    output  sel_m,
    output [WIDTH-1:0] wdata_mfifo,    //interface
    output wen_mfifo,                   //interface
    output wenreg_s,                    //interface
    output renreg_s                     //interface
);







apbs#(.WIDTH(32), .ADDRBITS(16)) apbstop
(
    //standard
    .apb_clk(apb_clk),
    .reset(reset),
    .psel(sel_s),
    .penable(en_s),
    .pwrite(write_s),
    .paddr(outaddr_s),
    .pwdata(wdata_s),
    .pready(ready_s),
    .prdata(rdata_s),

    //interface
    .rres(rres_sdec),
    .reg_read_data(regreaddata_s),
    .wait_fifo(wait_sfifo),
    .reg_write_data(regwritedata_s),
    .wrreq(wrreq_s),            //write or read req
    .wenfifo(wen_sfifo),         //write enable to fifo
    .wr(wr_senc),               //determined write or read
    .regaddr(regaddr_s),
    .wenreg(wenreg_s),
    .renreg(renreg_s),
    .en_rres(en_rres_s)
);


apbm#(.WIDTH(32),.ADDRBITS(16)) apbmtop
(
  //standard interface
  .apb_clk(apb_clk),
  .reset(reset),
  .prdata(rdata_m),
  .pready(ready_m),
  .dec_en(dec_en_m),
  .psel(sel_m),
  .penable(en_m),
  .pwrite(write_m),
  .paddr(outaddr_m),
  .pwdata(wdata_m),

  // interface in this design
  .wr(wr_mdec),
  .wait_fifo(wait_mfifo),
  .daddr(daddr_mdec),
  .wdatadec(wdata_mdec),
  .read_resfifo(wdata_mfifo),
  .wenfifom(wen_mfifo)
);
endmodule

 