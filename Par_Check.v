module Par_Check(
    input  wire         clk,
    input  wire         rst,
    input  wire  [7:0]  pdata,
    input  wire         samp_out,
    input  wire         par_type,
    input  wire         en,
    output  reg         par_err
);

reg  par_bit;

always @(*) begin
  if (par_type)
  begin
    par_bit = ~^pdata;  //odd parity
  end
  else begin
    par_bit = ^pdata;   //even parity
  end   
end

always @(posedge clk , negedge rst ) begin
     if(!rst)
     begin
     par_err <= 1'b0 ;
    end
    else if (en)
    begin
      par_err <= par_bit ^ samp_out;
    end
    else begin
        par_err <= 1'b0;
    end    
end
endmodule 