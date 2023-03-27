module wgreycount#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input w_clk,
    input reset,
    input wen , 
    input f_flag,
    output reg [ADDRBITS:0] wgrey,
    output wire [ADDRBITS:0] wptr

);

wire [ADDRBITS:0] next_WGrey;
wire [ADDRBITS:0] binary;


GtoB Greytobinary
(
    .din(wgrey),
    .dout(wptr)
);

assign binary = wptr + 'b1;


BtoG binary2grey
(
    .data_in(binary),
    .data_out(next_WGrey)

);
always@(posedge w_clk or negedge reset)
    begin
        if(!reset)
        begin
            wgrey <= 5'b0;
        end
        else if (!f_flag & wen)
        begin
            wgrey <= next_WGrey;
        end

    end


endmodule