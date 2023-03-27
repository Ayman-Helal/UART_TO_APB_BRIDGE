module ffp (
    input wire      clk,
    input wire      rst,
    input wire      en,
    input wire      in,
    output reg      out
);


always @(posedge clk ,negedge rst) 
 begin
    if (!rst)
    begin
        out <= 1'b0;
    end 
    else if (en)
    begin
        out <= in;
    end
    
end
endmodule 