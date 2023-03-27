module TX_fifo #(parameter WIDTH = 32,
parameter ADDRBITS = 4)
(   
    input [WIDTH-1:0] wdataf,
    input wenf , renf,
    input rclkf , wclkf, r_reset, w_reset,
    output [WIDTH-1:0] rdataf,
    output eflagf , fflagf,
    output [ADDRBITS-1:0] emptyloctopf


);


wire [4:0] Waddr;
wire [4:0] Wgrey;
wire [4:0] Rgrey;
wire [4:0] Raddr;
wire [4:0] RSyn;
wire [4:0] WSyn;
wire [4:0] ReadPtrSyn_binary;
wire [4:0]  WSyn_binary;


fifomem#( .WIDTH (WIDTH), .ADDRBITS (4)) fifomem
(
    .writedata(wdataf),
    .writeenable(wenf),
    .readenable(renf),
    .wclk(wclkf),
    .rclk(rclkf),
    .writeaddr(Waddr),
    .readaddr(Raddr),
    .readdata(rdataf),
    .rreset(r_reset),
    .wreset(w_reset)
);

wgreycount#(.WIDTH(WIDTH),.ADDRBITS (4)) wgreycounttop
(   .w_clk(wclkf),
    .reset(w_reset),
    .wen (wenf), 
    .f_flag(fflagf),
    .wgrey(Wgrey),
    .wptr(Waddr)
);

Rgreycount#(.WIDTH(WIDTH),.ADDRBITS (4)) rgreycounttop
(   .r_clk(rclkf),
    .reset(r_reset),
    .ren (renf), 
    .e_flag(eflagf),
    .rgrey(Rgrey),
    .rptr(Raddr)
);
Rsyn#(.WIDTH (WIDTH),.ADDRBITS(4))  Rsyntop 
(
   .w_clk(wclkf),
   .reset(w_reset),
   .rgrey(Rgrey),
   .r_syn(RSyn)
);

Wsyn#(.WIDTH (WIDTH),.ADDRBITS(4))  Wsyntop 
(
   .r_clk(rclkf),
   .reset(r_reset),
   .wgrey(Wgrey),
   .w_syn(WSyn)
);
full#(.WIDTH(WIDTH),.ADDRBITS(4)) fulltop
(   
    .writeptr(Waddr),
    .readptrsyn(ReadPtrSyn_binary),
    .f_flag(fflagf)

);
GtoB#(.WIDTH(WIDTH),.ADDRBITS(4)) GtoB3
(
    .din(WSyn),
    .dout(WSyn_binary)
);
empty #(.WIDTH(WIDTH),.ADDRBITS(4)) emptytop
(   
    .readptr(Raddr),
    .writeptrsynbinary(WSyn_binary),
    .e_flag(eflagf)

);

GtoB#(.WIDTH(WIDTH),.ADDRBITS(4)) GtoB2
(
    .din(RSyn),
    .dout(ReadPtrSyn_binary)
);
emptyloc#(.WIDTH(WIDTH),.ADDRBITS(4)) emptyloc
(
    .readptrsynbinary(ReadPtrSyn_binary), //syn to the clock which the fifo write in
    .wptr(Waddr),
    .emptyloc(emptyloctopf)
);
endmodule