module fifomem #(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(
    input rclk,wclk,
    input rreset,wreset,
    input[WIDTH-1 :0]  writedata,
    input writeenable,
    input readenable,
    input [ADDRBITS:0] writeaddr,
    input [ADDRBITS:0] readaddr,
    output reg [WIDTH-1:0] readdata
);

reg [WIDTH-1:0] FIFO [0:15];


integer i;
always@(posedge wclk , negedge wreset)
    begin
        if (!wreset)
        begin
            
        for(i=0; i<16; i=i+1)
        begin
            FIFO [i] <= 'b0;
        end
        end 
        else if(writeenable)
            FIFO[writeaddr] <= writedata; 
    end

always@(posedge rclk , negedge rreset)
    begin
        if (!rreset)
        begin
            readdata <= 'b0;
        for(i=0; i<16; i=i+1)
        begin
            FIFO [i] <= 'b0;
        end
        end 
        else if (readenable)
            readdata <= FIFO[readaddr];
    end




    endmodule


