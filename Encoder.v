module Encoder (
    input  wire   [47:0]  write_read_req,
    input  wire           wr,
    output wire   [55:0]  write_read_cmd
);

reg [7:0] head;

always @(*)
 begin
    case (wr)
        1'b1: begin
            head = 8'H02;
        end
        1'b0: begin
            head = 8'H03;
        end
        default:head = 8'b0; 
    endcase    
end

assign write_read_cmd = {head,write_read_req};

endmodule

