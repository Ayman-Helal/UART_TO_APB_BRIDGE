module Stop_Check(
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire        samp_out,
    output  reg        stop_err
);

always @(posedge clk , negedge rst) begin
    if (!rst)
    begin
        stop_err <= 1'b0;
    end
    else if (en)
    begin
        stop_err <= !samp_out;
    end
    else begin
        stop_err <= 1'b0;
    end  
    
end

endmodule