module apbm#(parameter WIDTH = 32,
parameter ADDRBITS = 16)
 (
  //standard interface
  input                     apb_clk,
  input                     reset,
  input [WIDTH-1:0]         prdata,              //data from slave
  input                     pready,                          // indicates salve data is ready
  output reg                psel, 
  output reg                penable,
  output reg                pwrite,
  output reg [ADDRBITS-1:0] paddr,
  output reg [WIDTH-1:0]    pwdata,

  // interface in this design
  input wr,                             // write or read req
  input wait_fifo,                      // if fifo is full
  input dec_en,                         // enable to indicate transaction from decoder
  input [ADDRBITS-1:0] daddr,           // address from decoder
  input [WIDTH-1 :0] wdatadec,          // w or r read
  output reg [WIDTH-1:0] read_resfifo,  // response
  output reg wenfifom                   //enable to fifo
);
  
  reg [1:0] state ;
  reg [1:0] nextstate;

  localparam [1:0]  IDLE    = 2'b00,
                    SETUP   = 2'b01,
                    ACCESS  = 2'b10;

always@(posedge apb_clk or negedge reset)
    begin
        if( !reset )
              state <= IDLE; 
        else
              state <= nextstate;
    end 

                    
  // next state logic              
  always @(*)
    begin
        case(state)
          IDLE: 
            begin
                if(dec_en)  // there is a transaction
                    begin
                        nextstate = SETUP;
                    end
                else 
                    begin
                        nextstate = IDLE;
                    end
            end
            
          SETUP:
            begin
              nextstate  = ACCESS;
            end
                
          ACCESS:
             begin
              if(!pready|wait_fifo)  // if slave is not ready or fifo full stay in access
              begin
                nextstate = ACCESS;
              end
              else                    // finish the transaction           
                begin
                  if(dec_en)          // if new transaction
                      nextstate= SETUP;   
                  else
                    nextstate=IDLE;
                end
             end
              default: 
              begin
                nextstate = IDLE;
              end
            endcase
          end

// output logic
always @(*)
    begin
        case (state)
          IDLE: 
              begin
                psel    =1'b0;         
                penable =1'b0;
                pwrite  =1'b0;
                paddr   = 16'b0;
                pwdata  = 32'b0;
                wenfifom =1'b0;
                read_resfifo = 'b0;
              end
          SETUP:
              begin
                psel    =1'b1;         
                penable =1'b0;
                paddr   = 16'b0;
                pwdata  = 32'b0;
                wenfifom =1'b0;
                read_resfifo = 'b0;
                if (wr)
                begin
                   pwrite  =1'b1;
                end
                else 
                begin
                  pwrite = 1'b0;
                end
              end
          ACCESS:
              begin
                psel =1;
                penable = 1;
                if(wr)          //write req
                  begin
                    pwrite =1'b1;
                    pwdata = wdatadec;
                    paddr  = daddr;
                  end
                else          // read req
                  begin
                    pwrite =1'b0;
                    paddr = daddr;
                    if(pready&!wait_fifo) 
                      begin
                        read_resfifo = prdata;
                        wenfifom =1'b1;
                      end
                    else
                      begin
                        wenfifom =1'b0;
                      end

                  end
              end
              default: 
              begin
                nextstate = IDLE;
              end
        endcase
    end          
endmodule