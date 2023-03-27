module Frame_FSM_tx (
    input wire       ParEN,
    input wire       CLK,
    input wire       RST,
    input wire       tx_en,
    input wire       DataVLD,
    input wire       Ser_Done,
    output reg [1:0] sel,
    output reg       ParON,
    output reg       SerEN, 
    output reg       FBUSY  
);

localparam IDLE = 2'b00, 
           START = 2'b01,
           DATA = 2'b10,
           PARITY = 2'b11;

reg [1:0] current_state, next_state;

always @(posedge CLK or negedge RST)
  begin
   if (!RST)
     begin 
       current_state <= IDLE;
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

//Next State Logic 

always @(*) 
 begin

    case (current_state)
       IDLE: begin
        if(DataVLD)
         begin
            next_state = START;
        end
        else begin
            next_state = IDLE;
        end
       end
       START: begin
        next_state = DATA;
       end
       DATA: begin
        if (Ser_Done)
         begin
            if(ParEN)
            begin
                next_state = PARITY;
            end
            else begin
                next_state = IDLE;
            end
        end
        else begin
            next_state = DATA;
        end
       end
       PARITY: begin
        next_state = IDLE;
       end 
        default: next_state = IDLE;
    endcase  
end

// Output logic

always @(*)
 begin
    case (current_state)
        IDLE: begin
            sel = 2'd0;
            SerEN = 1'b0;
            FBUSY = 1'b0; 
            ParON = 1'b0;            
        end
        START: begin
            sel = 2'd1;
            SerEN = 1'b0;
            FBUSY = 1'b1; 
            ParON = 1'b0;                      
        end
        DATA: begin
            sel = 2'd2;
            SerEN = 1'b1;
            FBUSY = 1'b1; 
            ParON = 1'b0; 
        end
        PARITY: begin
            sel = 2'd3;
            SerEN = 1'b0;
            FBUSY = 1'b1; 
            ParON = 1'b1;           
        end 
        default: begin
            sel = 2'd0;
            SerEN = 1'b0;
            FBUSY = 1'b0; 
            ParON = 1'b0;    
        end 
    endcase
    
end

    
endmodule