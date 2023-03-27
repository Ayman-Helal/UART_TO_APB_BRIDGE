module Edge_Counter (
    input  wire          clk,
    input  wire          rst,
    input  wire          en,
    input  wire  [5:0]   scale,
    output wire          edge_done, 
    output wire          edge_done_m2, 
    output  reg  [4:0]   edge_count
);

always @(posedge clk , negedge rst) begin
    if (!rst)
    begin
        edge_count <= 5'b0;
    end
    else if(en)
    begin
        if(edge_done)
        begin
            edge_count <= 5'b0;
        end
        else begin
        edge_count <= edge_count + 5'd1;
        end
    end
    else begin
        edge_count <= edge_count;
    end
end

 assign edge_done = (edge_count==(scale - 1))? 1'b1:1'b0;
assign edge_done_m2 = (edge_count==(scale - 2))? 1'b1:1'b0;
endmodule