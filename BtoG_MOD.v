module BtoG_MOD #(parameter width = 16)
(
    input                   clk,
    input                   rst,  
    input       [width-1:0] data_in,
    output reg  [width-1:0] data_out
);

reg  [width-1:0] data_out_reg;
integer i;

always @(*)
 begin

  data_out_reg[width-1] = data_in[width-1];

    for(i=width; i>1; i=i-1)
     begin
            data_out_reg[i-2] = data_in[i-1]^data_in[i-2];
     end
    
end

always @(posedge clk , negedge rst) begin
  if (!rst)
  begin
     data_out <= 'b0;
  end 
  else begin
    data_out <= data_out_reg; 
end
end
endmodule 






