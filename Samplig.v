module Sampling (
    input  wire         clk,
    input  wire         rst,
    input  wire         sdata,
    input  wire         samp_en,
    input  wire  [4:0]  edge_count,
    input  wire  [5:0]  scale,
    output  reg         samp_out
);

reg  [2:0] sample;



wire [3:0]    half_edges,
              half_edges_p1,
			        half_edges_n1;



assign 	half_edges  =  (scale >> 1) - 1'b1;
assign 	half_edges_p1 =  half_edges + 'b1 ;
assign 	half_edges_n1 =  half_edges - 'b1 ;

always @ (posedge clk , negedge rst)
 begin
  if(!rst)
   begin
    sample <= 3'b0 ;
   end
  else 
   begin
    if(samp_en) 
	 begin
	  if(edge_count == half_edges_n1)
       begin
        sample[0] <= sdata;
       end	
      else if(edge_count == half_edges)
       begin
        sample[1] <= sdata;
       end	
      else if(edge_count == half_edges_p1)
       begin
        sample[2] <= sdata;
       end
     end
    else
     begin
      sample <= 'b0;
     end 
   end	 
 end


 always @ (posedge clk, negedge rst)
 begin
  if(!rst)
   begin
    samp_out <= 1'b0 ;
   end
  else
   begin
    if(samp_en) 
	 begin
      case (sample)
      3'b000 : begin
                samp_out<= 1'b0 ;
               end	
      3'b001 : begin
                samp_out<= 1'b0 ;
               end
      3'b010 : begin
                samp_out<= 1'b0 ;
               end	
      3'b011 : begin
                samp_out<= 1'b1 ;
               end	
      3'b100 : begin
                samp_out<= 1'b0 ;
               end
      3'b101 : begin
                samp_out<= 1'b1 ;
               end	
      3'b110 : begin
                samp_out<= 1'b1 ;
               end
      3'b111 : begin
                samp_out<= 1'b1 ;
               end
      endcase
     end
    else
     begin
       samp_out<= 1'b0 ;
     end	 
   end
 end 

endmodule
 
