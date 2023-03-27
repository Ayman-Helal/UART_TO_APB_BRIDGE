module Start_Check(
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire        edge_done,
    input  wire        samp_out,
    output  reg        start_err
);

always @(posedge clk , negedge rst) begin
    if (!rst)
    begin
        start_err <= 1'b0;
    end
    else if (en & edge_done)
    begin
        start_err <= samp_out;
    end
    else begin
        start_err <= 1'b0;
    end  
    
end

endmodule