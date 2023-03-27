module emptyloc#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input [ ADDRBITS:0] readptrsynbinary, //syn to the write clk
    input [ ADDRBITS:0] wptr,
    output reg [ADDRBITS-1:0] emptyloc
    
);

always@(*)
    begin
        if(wptr > readptrsynbinary)
            emptyloc = 4'd15 -(wptr-readptrsynbinary);
        else if(readptrsynbinary > wptr)
            emptyloc = (readptrsynbinary-wptr);
        else
            begin
                emptyloc =4'd15;
            end
    end


endmodule 