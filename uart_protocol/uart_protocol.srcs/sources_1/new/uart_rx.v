`timescale 1ns/1ps
module uart_rx(clk,reset,rx_in,rx_en,rx_uld,rx_data,rx_empty);   

input rx_in;input rx_en;input rx_uld,clk,reset;
output reg [7:0]rx_data;output reg rx_empty;

reg [2:0] cnt=0;
reg [1:0]p_s;
reg [7:0]rx_reg;
parameter [1:0]IDLE=2'd0,START=2'd1,DATA=2'd2,STOP=2'd3;
always@(posedge clk or negedge reset)
begin
if(reset==0) begin
     rx_data<=1'b1;
     rx_empty<=1'b1; 
     cnt<=3 'b0;rx_reg<=0;
     p_s<=IDLE;
      end
    else
          begin
          // if(rx_uld && !rx_empty)begin
              rx_data<=rx_reg;
              rx_empty<=1'b0;end
          case(p_s)
               IDLE:begin
                      cnt<=0;
                          //  if(rx_en &&(rx_in==1'b0))begin
//                                      rx_empty<=0;
//                                      rx_data<=0;
                                      p_s<=START;end
                                    //   else
                                    //   p_s<=IDLE;
                                    // end           
                         

                START:begin
                 rx_empty<=0;
                  rx_data<=0;   
                //  if(rx_in==1'b0) 
                  p_s<=DATA;
                  // else
                  // p_s<=IDLE;
                end
                
                DATA:begin
                  
                  
                      rx_reg[cnt]<=rx_in;
                         if(cnt==3'd7)begin
                            cnt<=0;
                            p_s<=STOP; end
                            else begin
                             cnt<=cnt+1;
                             p_s<=DATA;
                              end
               end 
               STOP: begin
            // if(rx_in == 1'b1)
                rx_empty <= 1'b1;

            p_s <= IDLE;end
default: begin
                 p_s<=IDLE;
                       end
  endcase 
                
end

endmodule