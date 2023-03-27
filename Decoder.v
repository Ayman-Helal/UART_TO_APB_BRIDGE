module Decoder (
    input wire  [55:0]    data_in,
    input wire            en,
    input wire            clk,
    input wire            rst,
    output wire           REN,
    output reg  [31:0]    read_res,
    output reg  [15:0]    req_addr,
    output reg  [31:0]    req_data,
    output reg            master_en,
    output reg            slave_en,
    output reg            wr

);

wire [2:0]  cmd;
reg         en_reg;
reg  [31:0] read_res_reg;
reg  [31:0] req_data_reg;
reg  [15:0] req_addr_reg;
reg         wr_reg;       
reg         master_en_reg;
reg         slave_en_reg; 


localparam  WREQ = 3'd2,
            RREQ = 3'd3,
            RRES = 3'd4;


assign REN = (en)? 1'b1:1'b0;
assign cmd = data_in[50:48];

always @(posedge clk ,negedge rst) begin
    if (!rst)
    begin
      en_reg <= 1'b0;
    end
    else 
    en_reg <= en;   
end

always @(*)
 begin
    if (en_reg)
    begin
    case (cmd)
       WREQ : begin
        req_addr_reg  = data_in[47:32];
        req_data_reg  = data_in[31:0];
        read_res_reg  = 32'b0;
        wr_reg        = 1'b1;
        master_en_reg = 1'b1;
        slave_en_reg  = 1'b0;
 
       end 
       RREQ: begin
        req_addr_reg  = data_in[47:32];
        req_data_reg  = 32'b0;
        read_res_reg  = 32'b0;
        wr_reg        = 1'b0;
        master_en_reg = 1'b1;
        slave_en_reg  = 1'b0;

       end
       RRES: begin
        read_res_reg  = data_in[47:16];
        req_addr_reg  = 16'b0;
        req_data_reg  = 32'b0;
        master_en_reg = 1'b0;
        slave_en_reg  = 1'b1;
        wr_reg        = 1'b0;

       end
        default:begin
        req_addr_reg = 16'b0;
        req_data_reg = 32'b0;
        read_res_reg = 32'b0;
        wr_reg       = 1'b0;
        master_en_reg = 1'b0;
        slave_en_reg  = 1'b0;

        end 
    endcase
    end
    else begin
        req_addr_reg = 16'b0;
        req_data_reg = 32'b0;
        read_res_reg = 32'b0;
        wr_reg       = 1'b0; 
        master_en_reg = 1'b0;
        slave_en_reg  = 1'b0;

    end

end

always @(posedge clk , negedge rst)
begin
    if(!rst)
    begin
        req_addr <= 16'b0;
        req_data <= 32'b0;
        read_res <= 32'b0;
        wr        <= 1'b0;       
        master_en <= 1'b0;
        slave_en  <= 1'b0; 
    end
    else if (en_reg)
    begin
        req_addr <= req_addr_reg;
        req_data <= req_data_reg;
        read_res <= read_res_reg;
        wr        <= wr_reg;       
        master_en <= master_en_reg;
        slave_en  <= slave_en_reg;
    end
    else begin
        master_en <= 1'b0;
        slave_en  <= 1'b0;
    end 
end


endmodule 