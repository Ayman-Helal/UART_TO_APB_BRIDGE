module GtoB #(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input [ADDRBITS:0] din,
    output [ADDRBITS:0] dout
);

assign dout[4] =din[4];
assign dout[3] = dout[4]^din[3];
assign dout[2] = dout[3]^din[2];
assign dout[1] = dout[2]^din[1];
assign dout[0] = dout[1]^din[0];

endmodule