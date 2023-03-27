module Sel_FSM (
    input wire       clk,
    input wire       rst,
    input wire       vld,
    input wire       tx_en,
    input wire [2:0] count,
    output reg       sel
);


localparam IDLE_state = 1'b0, 
           RRES_state = 1'b1;

reg  current_state, next_state;

always @(posedge clk or negedge rst)
  begin
   if (!rst)
     begin 
       current_state <= IDLE_state;
     end
   else if (tx_en)
     begin
      current_state <= next_state;
     end
    else 
     begin
      current_state <= current_state;
     end
end


// next state logic


always @(*)
 begin
    case (current_state)
    IDLE_state: begin
     if (vld == 0)
     begin
     next_state = IDLE_state;
     end
     else begin
      next_state = RRES_state;
     end  
    end
    
    RRES_state: begin
        if (count == 3'd4)
        begin
              next_state = IDLE_state;  
        end
        else begin
            next_state = RRES_state;
        end
    end
    default: next_state = IDLE_state; 
    endcase

end


always @(*) begin
    case (current_state)
        IDLE_state: sel = 1'b0;
        RRES_state: sel = 1'b1;
        default: sel = 1'b0;
    endcase
    
end
endmodule 