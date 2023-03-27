module Res_fifo #(parameter WIDTH = 32,
parameter ADDRBITS = 1)
(   
    input [WIDTH-1:0] wdata,
    input wen , ren,
    input rclk , wclk, w_reset, r_reset,
    output [WIDTH-1:0] rdata,
    output eflag , fflag

);


wire [4:0] Waddr;
wire [4:0] Wgrey;
wire [4:0] Rgrey;
wire [4:0] Raddr;
wire [4:0] RSyn;
wire [4:0] WSyn;
wire [4:0] RSyn_binary;
wire [4:0] WSyn_binary;



fifomem#( .WIDTH (32), .ADDRBITS (4)) fifomem
(
    .writedata(wdata),
    .writeenable(wen),
    .readenable(ren),
    .wclk(wclk),
    .rclk(rclk),
    .writeaddr(Waddr),
    .readaddr(Raddr),
    .readdata(rdata),
    .rreset(r_reset),
    .wreset(w_reset)
);

wgreycount#(.WIDTH(32),.ADDRBITS (4)) wgreycounttop
(   .w_clk(wclk),
    .reset(w_reset),
    .wen (wen), 
    .f_flag(fflag),
    .wgrey(Wgrey),
    .wptr(Waddr)
);

Rgreycount#(.WIDTH(32),.ADDRBITS (4)) rgreycounttop
(   .r_clk(rclk),
    .reset(r_reset),
    .ren (ren), 
    .e_flag(eflag),
    .rgrey(Rgrey),
    .rptr(Raddr)
);
Rsyn#(.WIDTH (32),.ADDRBITS(4))  Rsyntop 
(
   .w_clk(wclk),
   .reset(w_reset),
   .rgrey(Rgrey),
   .r_syn(RSyn)
);

Wsyn#(.WIDTH (32),.ADDRBITS(4))  Wsyntop 
(
   .r_clk(rclk),
   .reset(r_reset),
   .wgrey(Wgrey),
   .w_syn(WSyn)
);

GtoB#(.WIDTH(32),.ADDRBITS(4)) GtoB6
(
    .din(RSyn),
    .dout(RSyn_binary)
);
full#(.WIDTH(32),.ADDRBITS(4)) fulltop
(   
    .writeptr(Waddr),
    .readptrsyn(RSyn_binary),
    .f_flag(fflag)

);

GtoB#(.WIDTH(32),.ADDRBITS(4)) GtoB7
(
    .din(WSyn),
    .dout(WSyn_binary)
);
empty#(.WIDTH(32),.ADDRBITS(4)) emptytop
(   
    .readptr(Raddr),
    .writeptrsynbinary(WSyn_binary),
    .e_flag(eflag)
);
endmodule