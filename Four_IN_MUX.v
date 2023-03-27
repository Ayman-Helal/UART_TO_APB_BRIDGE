module Four_IN_MUX #(parameter width = 1) (
    input wire  [width-1:0]   IN0,
    input wire  [width-1:0]   IN1,
    input wire  [width-1:0]   IN2,
    input wire  [width-1:0]   IN3,
    input wire  [1:0]         sel,
    output reg  [width-1:0]   OUT              
);

always @(*) 
 begin
    OUT = 'b0;
  case (sel)
    2'd0: OUT = IN0;
    2'd1: OUT = IN1;
    2'd2: OUT = IN2;
    2'd3: OUT = IN3;
    default: OUT = 'b0;
  endcase 
end
    
endmodule