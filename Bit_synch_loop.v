module Bit_synch_loop (
    input wire       data_in,
    input wire       clk,
    input wire       rst,
    output reg       synch_data
);

reg  first_ff_out;

always @(posedge clk, negedge rst )
 begin
    if (!rst)
    begin
        first_ff_out <= 1'b1;
    end
    else begin
        first_ff_out <= data_in;
    end   
end

always @(posedge clk , negedge rst) 
 begin
    if (!rst)
    begin
        synch_data <= 1'b1;
    end
    else begin
        synch_data <= first_ff_out;
    end     
end
    
endmodule