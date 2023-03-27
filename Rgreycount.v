module Rgreycount#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input r_clk,
    input reset,
    input ren , 
    input e_flag,
    output reg [ADDRBITS:0] rgrey,
    output  wire [ADDRBITS:0] rptr

);

wire [ADDRBITS:0] bin_outR;
wire [ADDRBITS:0] next_RGrey;


GtoB Greytobinary
(
    .din(rgrey),
    .dout(rptr)
);

assign bin_outR = rptr + 'b1; 

BtoG binary2grey
(
    .data_in(bin_outR),
    .data_out(next_RGrey)

);
always@(posedge r_clk or negedge reset)
    begin
        if(!reset)
            rgrey <= 5'b0;
        else if (!e_flag & ren)
            rgrey <= next_RGrey;
    end


endmodule