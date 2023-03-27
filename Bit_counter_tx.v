module Bit_counter_tx (
    input wire      EN,
    input wire      ParEN,
    input wire      tx_en,
    input wire      CLK,
    input wire      RST,
    output reg      Done
);

reg [4:0] count_out;



always @(posedge CLK , negedge RST) 
 begin
    if(!RST)
    begin
        count_out <= 4'b0;
    end
    else if (EN & tx_en) 
    begin
        case (ParEN)
            1'b0: begin
                if (count_out == 4'd10)
                begin
                    count_out <= 4'b0;
                end
                else begin 
                    count_out <= count_out +4'd1;
                end
            end
            1'b1: begin
                if (count_out == 4'd11)
                begin
                    count_out <= 4'b0;
                end
                else begin 
                    count_out <= count_out +4'd1;
                end                
            end
            default: count_out <= count_out;
        endcase        
    end
    else begin
        count_out <= count_out;        
    end 
end

always @(*) begin
    if (ParEN)
    begin
        if (count_out == 4'd11)
        begin
            Done = 1'b1;
        
        end
        else begin
            Done = 1'b0;
            
        end   
    end
    else begin
        if (count_out == 4'd10)
        begin
            Done = 1'b1;
           
        end
        else begin
            Done = 1'b0;
            
        end          
    end  
end
   
endmodule
    
