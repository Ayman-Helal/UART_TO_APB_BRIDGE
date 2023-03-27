module RX_TX_Scale (
    input wire   [1:0] tx_rate,
    output reg   [5:0] scale
);

always @(*) begin
    case (tx_rate)
        2'b00: scale = 6'd32;
        2'b01: scale = 6'd16;
        2'b10: scale = 6'd8;
        default: scale = 6'd32;
    endcase   
end
    
endmodule