module Reg_Out (
    input  wire  [7:0]  data_in,
    input  wire         full,
    input  wire         clk,
    input  wire         rst,
    input  wire         data_vld,
    input  wire         tx_clock,
    output  reg         out_data_vld,
    output wire   [55:0] pdata
);


wire wr_en;
reg [2:0] cmd;
reg [2:0] count;


assign  wr_en = !full & data_vld;

reg [7:0] MEM [6:0];

localparam WREQ = 3'd2, 
           RREQ = 3'd3,
           RRES = 3'd4;



always @(posedge clk ,negedge rst) 
begin
    if (!rst)
    begin
        count <= 3'b0;
    end 
    else if (out_data_vld == 1'b1)
    begin
        count <= 3'b0;
    end
    else if (wr_en)
    begin
        count <= count + 3'd1; 
    end
    else begin
        count <= count;
    end    
end


always @(posedge clk , negedge rst) begin
    if(!rst)
    begin
        cmd <= 3'd0;
    end
    else if (count == 3'b0 & wr_en)
    begin
        cmd <= data_in[2:0];
    end
    else begin
        cmd <= cmd;
    end
    
end


integer i;
always @(posedge clk , negedge rst)
 begin
    if (!rst)
    begin
        for(i=0; i<3'd7; i=i+1)
        begin
            MEM [i] <= 8'b0;
        end 
    end 

    else if (wr_en) 
    begin
    MEM[count] <= data_in;
    end
end



always @(*) begin
    out_data_vld = 1'b0; 
     case (cmd)
        WREQ: begin
            if (count == 3'd7)
            begin
                 out_data_vld = 1'b1;   
            end
            else begin
                 out_data_vld = 1'b0; 
            end
        end
        RREQ: begin
            if (count == 3'd3)
            begin
                 out_data_vld = 1'b1;   
            end
            else begin
                 out_data_vld = 1'b0; 
            end
        end  
        RRES: begin
            if (count == 3'd5)
            begin
                 out_data_vld = 1'b1;   
            end
            else begin
                 out_data_vld = 1'b0; 
            end
        end 
        default: out_data_vld = 1'b0; 
    endcase
    
end


 assign pdata = {MEM[0],MEM[1],MEM[2],MEM[3],MEM[4],MEM[5],MEM[6]};



endmodule 