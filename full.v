module full#(parameter WIDTH = 32,
parameter ADDRBITS= 4)
(   
    input [ADDRBITS:0] writeptr,
    input [ADDRBITS:0] readptrsyn,
    output reg f_flag

);
always@(*)
    begin
        if((({~readptrsyn[4], readptrsyn[3:0]})== writeptr))
            f_flag =1;
        else
            f_flag =0;
    
    end



endmodule