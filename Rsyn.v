module Rsyn#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
   input w_clk,
   input reset,
   input [ADDRBITS:0] rgrey,
   output reg [ADDRBITS:0] r_syn
);
  
 reg [ADDRBITS:0] sync_flop1;
 
  
  always @(posedge w_clk or negedge reset)
    begin
      if(!reset)
        begin
          sync_flop1 <= 5'b0;
          r_syn  <= 5'b0;
        end
      else begin
          sync_flop1 <= rgrey;
          r_syn <= sync_flop1;
      end
    end
endmodule 