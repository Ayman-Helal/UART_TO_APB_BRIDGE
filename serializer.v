module serializer (
    input wire        CLK,
    input wire        RST,
    input wire        tx_en,
    input wire [7:0]  Data,
    input wire        EN,
    output wire       Done,
    output reg        SData
);

reg [2:0] count;

always @(posedge CLK , negedge RST) 
 begin
    if(!RST)
    begin
        count <= 3'b111;
    end
    else if (EN & tx_en)
    begin
        if (!Done)
        begin
        count <= count - 3'd1;
        end
        else begin
        count <= 3'b111;
        end
    end
    else begin
        count <= count;
    end    
end

always @(*) 
 begin
    if (EN)
    begin
        SData = Data[count];
    end
    else begin
        SData = 1'b0;
    end     
end

assign Done = (count == 3'b0) ? 1'b1 : 1'b0 ;
    
endmodule