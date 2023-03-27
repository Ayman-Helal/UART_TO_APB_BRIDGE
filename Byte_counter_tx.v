module Byte_counter_tx (
    input wire       EN,
    input wire       CLK,
    input wire       tx_en,
    input wire       SRST,
    input wire       BYCRST,
    input wire       BitDone,
    output reg [2:0] counter_out
);

wire CEN;

assign CEN = EN & BitDone;

always @(posedge CLK , negedge SRST) begin
    if (!SRST)
    begin 
        counter_out <= 3'b0;
    end
    else if (!BYCRST)
    begin
        counter_out <= 3'b0;
    end
    else if (CEN & tx_en)
    begin
        counter_out <= counter_out + 3'd1; 
    end 
    else begin
        counter_out <= counter_out;
    end
    
end


    
endmodule