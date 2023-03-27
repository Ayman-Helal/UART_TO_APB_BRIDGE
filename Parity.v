module Parity (
 input   wire       CLK,
 input   wire       RST,
 input   wire       tx_en,
 input   wire       parity_enable,
 input   wire       parity_type,
 input   wire       Err, 
 input   wire [7:0] DATA,
 output  reg        Err_done,
 output  reg        parityBit 

);

reg parity, Err_done_reg;

always @ (posedge CLK or negedge RST)
begin
  if(!RST)
   begin
    parity <= 1'b0 ;
   end
  else 
   begin
    if (parity_enable)
	 begin
	  case(parity_type)
	  1'b0 : begin                 
	          parity <= ^DATA ;     // Even Parity
	         end
	  1'b1 : begin
	          parity <= ~^DATA ;     // Odd Parity
	         end		
	  endcase       	 
	 end
   end
end 

always @(*) begin
    if(Err)
    begin
        parityBit = ~parity;
        Err_done_reg = 1'b1;
    end
    else begin
        parityBit = parity;
        Err_done_reg = 1'b0;
    end
 end


always @(posedge CLK, negedge RST) begin
    if (!RST)
    begin
        Err_done <= 1'b0;
    end
    else begin 
        Err_done <= Err_done_reg;
    end

end

endmodule