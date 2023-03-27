module Bus_Synch #(parameter BUS_WIDTH = 16)
(
    input   wire    [BUS_WIDTH - 1 : 0]     data_in,
    input   wire                            clk,
    input   wire                            rst,
    output  wire    [BUS_WIDTH - 1 : 0]     synch_data    
);

    genvar  i;

    for (i = 0 ; i < BUS_WIDTH ; i = i+1) begin
        Bit_synch  U0  (.data_in(data_in[i]), .clk(clk), .rst(rst), .synch_data(synch_data[i]));
    end

endmodule