module Two_IN_MUX #(parameter width =56) (
    input wire  [width-1:0]  IN0,
    input wire  [width-1:0]  IN1,
    input wire               sel,
    output reg  [width-1:0]  OUT
);

always @(*) 
 begin

    case (sel)
        1'b0: OUT = IN0;
        1'b1: OUT = IN1;
        default: OUT = 'd1; 
    endcase   
end
    
endmodule