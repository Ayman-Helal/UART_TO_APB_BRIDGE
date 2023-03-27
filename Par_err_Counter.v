module Par_err_Counter (
    input  wire          clk,
    input  wire          rst,
    input  wire          clr,   
    input  wire          en,
    input  wire          par_err, 
    input  wire          edge_done, 
    output  reg  [15:0]  par_err_count
);

always @(posedge clk , negedge rst) begin
    if (!rst)
    begin
        par_err_count <= 16'b0;
    end
    else if (clr)
    begin
        par_err_count <= 16'b0;        
    end
    else if(en & par_err & edge_done)
    begin
        par_err_count <= par_err_count + 16'd1;
    end
    else begin
        par_err_count <= par_err_count;
    end
end

endmodule 