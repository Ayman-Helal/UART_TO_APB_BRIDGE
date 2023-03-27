module emptylocf2#(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input [ ADDRBITS:0] writeptrsynbinary, //syn to the write clk
    input [ ADDRBITS:0] readptr,
    output reg [ADDRBITS-1:0] empty_locf2
);

always@(*)
    begin
        if(writeptrsynbinary > readptr)
            empty_locf2 = 4'd15 -(writeptrsynbinary-readptr);
        else if(readptr > writeptrsynbinary)
            empty_locf2 = (readptr-writeptrsynbinary);
        else
            empty_locf2=4'd15;
    end


endmodule 
    
