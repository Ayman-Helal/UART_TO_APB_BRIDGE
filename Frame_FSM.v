module Frame_FSM (
    input  wire           clk,   
    input  wire           rst,  
    input  wire           sdata,
    input  wire           par_en,
    input  wire           edge_done,
    input  wire           edge_done_m2,
    input  wire   [3:0]   bit_count,
    input  wire           par_err,
    input  wire           str_err,
    input  wire           stp_err,
    output  reg           samp_en,
    output  reg           bit_count_en,
    output  reg           edge_count_en,
    output  reg           par_chk_en,
    output  reg           str_chk_en,
    output  reg           stp_chk_en,
    output  reg           deser_en,   
    output  reg           data_valid

);

localparam IDLE_STATE  = 3'b000, 
           START_STATE = 3'b001,
           DATA_STATE  = 3'b010,
           PARI_STATE  = 3'b011,
           STOP_STATE  = 3'b100,
           ERROR_STATE = 3'b101,
           VALID_STATE = 3'b110;


reg [2:0] current_state, next_state;


always @(posedge clk or negedge rst)
  begin
   if (!rst)
     begin 
       current_state <= IDLE_STATE;
     end
   else 
     begin
      current_state <= next_state;
     end    
end


//Next state Logic

always @(*) 
begin

    case (current_state)
        IDLE_STATE: begin

            if (sdata)
            begin
                next_state = IDLE_STATE;
            end
            else begin
                next_state = START_STATE;
            end
        end
        START_STATE: begin
            if(edge_done && bit_count ==4'd0)
            begin
                if (str_err)
                begin
                    next_state = IDLE_STATE;
                end
                else begin
                    next_state = DATA_STATE;
                end
            end
            else begin
                next_state = START_STATE;
            end
        end
        DATA_STATE: begin
            if(edge_done && bit_count == 4'd8) 
            begin
                if (par_en)
                 begin
                   next_state = PARI_STATE;
                end
                else 
                 begin
                    next_state = STOP_STATE;
                end
            end
            else begin
                next_state = DATA_STATE;
            end
        end
        PARI_STATE: begin
            if (edge_done)
            begin
                  next_state = STOP_STATE;
            end
            else begin
                next_state = PARI_STATE;
            end
        end 
        STOP_STATE: begin
          if (edge_done)
           begin
             if (stp_err | par_err)
            begin
                next_state = IDLE_STATE;
            end
            else begin
                next_state = VALID_STATE;
            end              
           end
          else begin
           next_state = STOP_STATE; 
           end
        end 
        VALID_STATE: begin
            if (!sdata) 
            begin
                next_state = START_STATE;
            end
            else begin
                next_state = IDLE_STATE;
            end
        end

        default: next_state = IDLE_STATE; 
    endcase
    
end 

//Output Logic

 always @(*) 
 begin
    case (current_state)
        IDLE_STATE: begin
            if (!sdata) begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b1;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b1;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b0;
            end

            else begin
            samp_en       = 1'b0;
            bit_count_en  = 1'b0;
            edge_count_en = 1'b0;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b0;
            end

        end
        START_STATE: begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b1;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b1;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b0;

        end
        DATA_STATE: begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b1;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b1;
            data_valid    = 1'b0;

        end
        PARI_STATE: begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b1;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b1;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b0;

        end 
        STOP_STATE: begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b1;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b1;
            deser_en      = 1'b0;
            data_valid    = 1'b0;
         
        end
  
        VALID_STATE: begin
            samp_en       = 1'b1;
            bit_count_en  = 1'b0;
            edge_count_en = 1'b1;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b1;            
        end
        default: begin
            samp_en       = 1'b0;
            bit_count_en  = 1'b0;
            edge_count_en = 1'b0;
            par_chk_en    = 1'b0;
            str_chk_en    = 1'b0;
            stp_chk_en    = 1'b0;
            deser_en      = 1'b0;
            data_valid    = 1'b0;
        end
    endcase
    
end

endmodule 
