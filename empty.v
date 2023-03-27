module empty#(parameter WIDTH = 32,
parameter ADDRBITS= 4)
(   
    input [ADDRBITS:0] readptr,
    input [ADDRBITS:0] writeptrsynbinary,
    output reg e_flag

);

always@(*)
    begin
        if(readptr == writeptrsynbinary) 
            e_flag =1;
        else
            e_flag =0;
    
    end


endmodule