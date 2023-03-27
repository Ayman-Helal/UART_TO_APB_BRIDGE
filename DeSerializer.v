module DeSerializer (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,   
    input  wire        samp_out,
    input  wire        edge_done,
    output  reg [7:0]  pdata 
);



always @(posedge clk ,negedge rst) 
 begin
  if(!rst)
   begin
    pdata <= 8'b0 ;
   end
  else if(en && edge_done)
   begin
    pdata <= {pdata[6:0],samp_out};
   end	
 end
endmodule  