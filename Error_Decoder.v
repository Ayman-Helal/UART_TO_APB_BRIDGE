module Error_Decoder (
    input wire [1:0] Err_type,
    input wire       Err_En,
    output reg       CMDErr,
    output reg       ADDErr,
    output reg       DataErr
);

always @(*) begin
    CMDErr = 1'b0;
    ADDErr = 1'b0;
    DataErr = 1'b0;
 if (Err_En) begin
    case (Err_type)
        2'd0: CMDErr = 1'b1;
        3'd1: ADDErr = 1'b1;
        3'd2: DataErr = 1'b1; 
        default: begin
            CMDErr = 1'b0;
            ADDErr = 1'b0;
            DataErr = 1'b0;
        end
    endcase
 end
 else begin
    CMDErr = 1'b0;
    ADDErr = 1'b0;
    DataErr = 1'b0;
 end
end
    
endmodule