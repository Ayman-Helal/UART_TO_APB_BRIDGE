module Clk_Div (
    input wire        clk,
    input wire        rst,
    input wire  [1:0] clk_rate,
    output reg        tx_en
);

reg [4:0] count;
reg [4:0] scale;

always @(*) 
begin
    case (clk_rate)
        2'b00: scale = 5'd31;
        2'b01: scale = 5'd15; 
        2'b10: scale = 5'd7; 
        default: scale = 6'd32;
    endcase  
end


always @(posedge clk ,negedge rst) 
begin
    if(!rst)
    begin
        count <= 5'b0;
        tx_en <= 1'b0;
    end
    else begin
        if (count == scale)
        begin
            count <= 5'b0;
            tx_en <= 1'b1;
        end
        else begin
            count <= count + 5'd1;
            tx_en <= 1'b0;            
        end
    end 

end

endmodule