module GtoB_MOD#(parameter width = 16)
(
    input       [width-1:0] din,
    output reg  [width-1:0] dout
);

integer i;
always @(*)
 begin

  dout[width-1] = din[width-1];

    for(i=width; i>1; i=i-1)
     begin
            dout[i-2] = din[i-1]^din[i-2];
     end
    
end
endmodule 

