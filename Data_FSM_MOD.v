module Data_FSM_MOD (
    input wire        CLK,
    input wire        RST,
    input wire        tx_en,
    input wire [55:0] PData,
    input wire [2:0]  count,
    input wire        CMDErr,
    input wire        ADDErr,
    input wire        DataErr,
    input wire        Data_VLD_tx,
    input wire        Data_VLD_res,
    input wire [2:0]  CMD,      
    input wire        Bit_done,
    input wire        FBUSY,
    output reg [7:0]  OutData,
    output reg        DataVLD_farme,
    output reg        ENBI,
    output reg        ENBY,
    output reg        DBUSY,
    output reg        sel,
    output reg        BYCRST,
    output reg        REN_tx,
    output reg        REN_res,
    output reg        Err    
);                              

localparam IDLE_STATE  = 3'b000,
           SETUP_STATE = 3'b001,
           WREQ_STATE  = 3'b010, 
           RRES_STATE  = 3'b011,         
           RREQ_STATE  = 3'b100;

localparam WREQ = 3'd2,
           RREQ = 3'd3,
           RRES = 3'd4;


reg [2:0] current_state, next_state;

always @(posedge CLK or negedge RST)
  begin
   if (!RST)
     begin 
       current_state <= IDLE_STATE;
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
    IDLE_STATE: begin
       if ((Data_VLD_tx | Data_VLD_res) & !FBUSY )
       begin
        next_state = SETUP_STATE;
       end

        else begin
            next_state = IDLE_STATE;
        end
    end
    SETUP_STATE: begin
                    case (CMD)
                WREQ: begin
                    next_state = WREQ_STATE;
                 end
                RREQ: begin
                    next_state = RREQ_STATE;
                 end
                RRES: begin
                    next_state = RRES_STATE;
                 end 
                default: next_state = IDLE_STATE;
            endcase
    end
    WREQ_STATE: begin
         if (count == 3'd6 & tx_en)
         begin 
             next_state = IDLE_STATE;
         end 
         else begin
             next_state = WREQ_STATE;
         end
    end
    RREQ_STATE: begin

         if (count == 3'd2 & tx_en)
         begin 
             next_state = IDLE_STATE;
         end 
         else begin
             next_state = RREQ_STATE;
         end
    end
    RRES_STATE: begin

        if (count == 3'd4 & tx_en)
        begin 
            next_state = IDLE_STATE;
        end 
        else begin
            next_state = RRES_STATE;
        end
    end 
    default: next_state = IDLE_STATE;
   endcase        
end


//Output logic

always @(*) 
begin

  case (current_state)
    IDLE_STATE: begin
           ENBI          = 1'b0;
           ENBY          = 1'b0; 
           Err           = 1'b0;
           BYCRST        = 1'b0;
           DataVLD_farme = 1'b0;
           DBUSY         = 1'b0;
           sel           = 1'b0;
           if (Data_VLD_res & tx_en)
           begin 
            REN_res = 1'b1;
            REN_tx  = 1'b0;
            sel     = 1'b1;
           end
           else if (Data_VLD_tx & tx_en)
           begin 
            REN_res = 1'b0;
            REN_tx  = 1'b1;
            sel     = 1'b0;
           end 
           else begin
            REN_res = 1'b0;
            REN_tx  = 1'b0;
            sel     = 1'b0;

           end
    end
    SETUP_STATE: begin
            OutData = 8'HFF;
            ENBI = 1'b0;
            ENBY = 1'b0; 
            Err = 1'b0;
            DBUSY = 1'b1;
            BYCRST = 1'b1;
            DataVLD_farme = 1'b0;
            REN_res = 1'b0;
            REN_tx = 1'b0;
        if(CMD == RRES)
         begin
             sel = 1'b1;
         end
        else begin
            sel = 1'b0;
        end 
    end

    WREQ_STATE: begin
           ENBI = 1'b1;
           ENBY = 1'b1; 
           DBUSY = 1'b1;
           DataVLD_farme = 1'b1;
           REN_res = 1'b0;
           REN_tx = 1'b0;
           sel    = 1'b0;

            case (count)
                3'd0: begin
                    OutData = PData[55:48];
                    BYCRST = 1'b1;
                    if (CMDErr)
                     begin
                        Err = 1'b1;
                     end
                    else begin
                        Err = 1'b0;
                     end                    
                end
                3'd1:begin
                    OutData = PData[47:40]; 
                    BYCRST = 1'b1;                    
                    Err = 1'b0;    
                end 
                3'd2:begin
                    OutData = PData[39:32]; 
                    BYCRST = 1'b1; 
                    if (ADDErr)
                    begin
                      Err = 1'b1;
                    end
                    else begin
                     Err = 1'b0;
                    end   
                end
                3'd3: begin
                    OutData = PData[31:24]; 
                    BYCRST = 1'b1;
                    Err = 1'b0;  
                end
                3'd4: begin
                    OutData = PData[23:16]; 
                    Err = 1'b0;
                    BYCRST = 1'b1;  
                end
                3'd5: begin
                    OutData = PData[15:8]; 
                    Err = 1'b0;
                    BYCRST = 1'b1;  
                end
                3'd6: begin
                    OutData = PData[7:0]; 
                    BYCRST = 1'b1;
                    if (DataErr)
                    begin
                      Err = 1'b1;
                    end
                    else begin
                     Err = 1'b0;
                    end    
                end
                3'd7: begin
                    OutData = 8'HFF; 
                    BYCRST = 1'b0;
                    Err = 1'b0;

                end

                default: begin
                     OutData = 8'HFF;
                     Err = 1'b0;
                     BYCRST = 1'b1;
                end
            endcase
    end
    RREQ_STATE: begin
           ENBI = 1'b1;
           ENBY = 1'b1; 
           DBUSY = 1'b1;
           DataVLD_farme = 1'b1;
           REN_res = 1'b0;
           REN_tx = 1'b0;
           sel    = 1'b0;
            case (count)
                3'd0: begin
                    OutData = PData[55:48];
                    BYCRST = 1'b1;
                    if (CMDErr)
                     begin
                        Err = 1'b1;
                     end
                    else begin
                        Err = 1'b0;
                     end                    
                end
                3'd1:begin
                    OutData = PData[47:40]; 
                    BYCRST = 1'b1;
                    Err = 1'b0;                    
                end 
                3'd2:begin
                    OutData = PData[39:32];   
                    BYCRST = 1'b1;   
                    if (ADDErr)
                    begin
                      Err = 1'b1;
                    end
                    else begin
                     Err = 1'b0;
                    end 
                end
                3'd3: begin
                    OutData = 8'HFF; 
                    BYCRST = 1'b0;
                    Err = 1'b0;
                end
                default: begin
                     OutData = 8'HFF;
                     Err = 1'b0;
                     BYCRST = 1'b1;
                end
            endcase
        end

    RRES_STATE: begin
           ENBI = 1'b1;
           ENBY = 1'b1; 
           DBUSY = 1'b1;
           DataVLD_farme = 1'b1;
           REN_res = 1'b0;
           REN_tx = 1'b0;
           sel  = 1'b1;

            case (count)
                3'd0: begin
                    OutData = PData[55:48];
                    BYCRST = 1'b1;
                    if (CMDErr)
                     begin
                        Err = 1'b1;
                     end
                    else begin
                        Err = 1'b0;
                     end                    
                end
                3'd1:begin
                    OutData = PData[47:40]; 
                    BYCRST = 1'b1;
                    Err = 1'b0;                    
                end 
                3'd2:begin
                    OutData = PData[39:32]; 
                    Err = 1'b0;
                    BYCRST = 1'b1;   
                end
                3'd3: begin
                    OutData = PData[31:24];  
                    BYCRST = 1'b1;
                    Err = 1'b0;
                end
                3'd4: begin
                    OutData = PData[23:16]; 
                    Err = 1'b0;
                    BYCRST = 1'b1;
                    if (DataErr)
                    begin
                      Err = 1'b1;
                    end
                    else begin
                     Err = 1'b0;
                    end   
                end
                3'd5: begin
                    OutData = 8'HFF; 
                    BYCRST = 1'b0;
                    Err = 1'b0; 


                end
                default: begin
                     OutData = 8'HFF;
                     Err = 1'b0;
                     BYCRST = 1'b1;
                end
            endcase
     end

    default: begin
            OutData = 8'HFF;
            ENBI = 1'b0;
            ENBY = 1'b0; 
            Err = 1'b0;
            DBUSY = 1'b0;
            BYCRST = 1'b1;
            DataVLD_farme = 1'b0;
            REN_res = 1'b0;
            REN_tx = 1'b0;
            sel  = 1'b0;
     end
  endcase   
end
    
endmodule