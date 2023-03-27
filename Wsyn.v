module Wsyn#(parameter WIDTH = 32,
parameter ADDRBITS= 4)
(
   input r_clk,
   input reset,
   input [ADDRBITS:0] wgrey,
   output reg [ADDRBITS:0] w_syn
);
  
 reg [ADDRBITS:0] sync_flop1;
  
  always @(posedge r_clk or negedge reset)
    begin
      if(!reset)
        begin
          sync_flop1 <= 5'b0;
          w_syn <= 5'b0;
        end
      else begin
          sync_flop1 <= wgrey;
          w_syn <= sync_flop1;
      end
    end

endmodule 