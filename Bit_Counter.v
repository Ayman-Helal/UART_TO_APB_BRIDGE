module Bit_Counter (
    input  wire         clk,
    input  wire         rst,
    input  wire         en,
    input  wire         par_en,
    input  wire         edge_done,
    output  reg [3:0]   bit_count
);
 
reg bit_done;

always @(posedge clk , negedge rst) begin
    if (!rst)
    begin
        bit_count <= 4'b0;
    end
    else if(en & edge_done)
    begin
        if (bit_done)
        begin
         bit_count <= 4'b0;
        end
        else begin
        bit_count <= bit_count + 4'd1;
        end
    end
    else begin
        bit_count <= bit_count;
    end
end


always @(*) begin
    case (par_en)
        1'b1: begin
            if(bit_count == 4'd10) 
            begin
                bit_done = 1'b1;
            end 
            else begin
                bit_done = 1'b0;
            end
        end
        1'b0: begin
            if(bit_count == 4'd9) 
            begin
                bit_done = 1'b1;
            end 
            else begin
                bit_done = 1'b0;
            end
        end

        default:bit_done = 1'b0; 
    endcase

end


endmodule 