module apbs#(parameter WIDTH = 32,
parameter ADDRBITS = 16)
(
    //standard
    input apb_clk,
    input reset,
    input psel,
    input penable,
    input pwrite,
    input [ADDRBITS-1:0] paddr,
    input [WIDTH-1:0] pwdata,
    output reg pready,
    output reg [WIDTH-1:0] prdata,

    //interface
    input wait_fifo ,                               // full fifo
    input [WIDTH-1:0] rres,                         // read response
    input [WIDTH-1:0] reg_read_data,                // data read from reg file
    input en_rres,                                  // response is ready
    output reg [WIDTH-1:0] reg_write_data,          // data write to reg file
    output reg [(WIDTH+ADDRBITS-1):0] wrreq,        //write or read req
    output reg wenfifo,                             //write enable to fifo
    output reg wr,                                  //determined write or read
    output reg [ADDRBITS-1:0] regaddr,              // address in reg file
    output reg wenreg,                              // when apb write in reg file
    output reg renreg                               // when apb read from reg file
    
    
);

reg [1:0] state, nextstate;
reg        flag;
reg [3:0]  count;

always @(posedge apb_clk , negedge reset) begin
    if (!reset)
    begin 
        count <= 4'b0;
    end 
    else if (!flag)
     count <= 4'b0;
    else if (count == 4'b1111)
     count <= count;
    else if (flag)
     count <= count + 4'b1; 
    else 
      count <= 4'b0;  
end


  localparam [1:0]  SETUP   = 2'b00,
                    WRITE   = 2'b01,
                    READ    = 2'b10;


always@( posedge apb_clk or negedge reset )
    begin

        if( !reset )
                state <= SETUP; 
        else
            state<= nextstate;

    end
// next state logic
    always@(*)
        begin
            case(state)
                SETUP:
                    begin
                        flag = 1'b0;
                        if(psel&pwrite)
                            nextstate = WRITE;
                        else if (psel&!pwrite)
                            nextstate = READ;
                        else
                            nextstate = SETUP;
                    end
                
                WRITE : 
                    begin
                        flag = 1'b0;
                     if (psel & !pwrite)
                            begin
                             nextstate = READ;
                            end
                     else if (psel &  pwrite)
                         begin
                            nextstate = WRITE;   
                         end    
                     else 
                        nextstate = SETUP;
                    end

                READ:
                    begin   
                     if (psel & !pwrite)
                            begin
                                flag = 1'b1;
                             nextstate = READ;
                            end
                     else if (psel &  pwrite)
                         begin
                            flag = 1'b1;
                            nextstate = WRITE;   
                         end    
                    else begin
                        flag = 1'b0;
                        nextstate = SETUP;
                    end
                    end

                default: begin
                    nextstate = SETUP;
                    flag = 1'b0;
                end
            endcase

            end
// output logic
always@(*)
    begin
        case(state)
            WRITE:
                begin
                    if(penable)
                        begin
                            if(paddr[15:5]==11'b11111111111) // address of reg file
                                begin
                                    regaddr = paddr;
                                    reg_write_data = pwdata;
                                    wenreg =1'b1;
                                    renreg =1'b0;
                                end
                            else 
                                begin
                                    wenfifo = 1'b1;
                                    wrreq = {paddr,pwdata};        
                                    wr=1'b1;                         // write req
                                    wenreg =1'b0;
                                    renreg =1'b0;
                                     if (wait_fifo)
                                     begin
                                        pready = 1'b0;
                                     end
                                     else begin
                                      pready = 1'b1; 
                                     end                  
                                end
                        end 
                        else begin
                            wenfifo = 1'b0;
                            wrreq = 'b0; 
                            wr=1'b0;                
                            wenreg =1'b0;
                            renreg =1'b0;
                            pready = 1'b0;
                            regaddr = 'b0;
                            reg_write_data = 'b0;
                        end
                        
                end
            READ:
                begin
                    if(penable)
                        begin
                            if(paddr[15:5]==11'b11111111111)
                                begin
                                    regaddr = paddr;
                                    prdata = reg_read_data;
                                    renreg = 1'b1;
                                    wenreg =1'b0;
                                    pready = 1'b1;
                                end
                            else
                                begin
                                    wrreq = {paddr,32'b0}; 
                                    wr=1'b0;                   //read req
                                    wenreg =1'b0;
                                    renreg =1'b0;
                                    if(en_rres==1'b1) // Response is ready
                                        begin
                                            prdata = rres;
                                            pready = 1'b1;
                                        end
                                    else
                                            pready =1'b0;

                                    if (count < 4'd1)
                                    begin 
                                        wenfifo = 1'b1;
                                    end
                                    else begin
                                    wenfifo = 1'b0;
                                    end 

                                end
                        end

                        else begin
                            regaddr = 'b0;
                            prdata = 'b0;
                            renreg = 1'b0;
                            wenreg =1'b0;
                            pready = 1'b0;
                            wr=1'b0; 
                            wenfifo = 1'b0;
                            wrreq = 'b0;                            
                        end
                end
                default:  begin
           pready = 1'b0;
           prdata = 'b0;
           reg_write_data = 'b0;
           wrreq = 'b0;
           wenfifo = 'b0;
           wr = 'b0;
           regaddr = 'b0;
           wenreg = 'b0;
           renreg ='b0;
        end
        endcase
    end
endmodule



                                
                                




       
        