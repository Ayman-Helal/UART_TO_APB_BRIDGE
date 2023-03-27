module BtoG#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input [ADDRBITS:0] data_in,
    output  [ADDRBITS:0] data_out
);
assign data_out[4] = data_in[4];
assign data_out[3] = data_in[4]^data_in[3];
assign data_out[2] = data_in[3]^data_in[2];
assign data_out[1] = data_in[2]^data_in[1];
assign data_out[0] = data_in[1]^data_in[0];


endmodule