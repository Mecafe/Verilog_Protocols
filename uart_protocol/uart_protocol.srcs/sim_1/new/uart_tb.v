`timescale 1ns/1ps 

module uart_tb();


reg clk;
reg reset;
reg wr_en;             
reg ld_tx;             
reg [7:0] tx_din;      

//  reg rx_in;
 reg rx_en;
 reg rx_uld;

 
wire tx_dout;           
wire tx_empty;         

 wire [7:0]rx_data;
  wire rx_empty;



uart_tx DUT1(clk,reset,wr_en,tx_din,ld_tx,tx_dout,tx_empty); 
uart_rx DUT2(clk,reset,tx_dout,rx_en,rx_uld,rx_data,rx_empty); 


always #5 clk= ~clk;

initial begin
    clk <= 0;
    reset  <= 0;
    wr_en <=  0;              
    ld_tx  <= 0;               
    tx_din <= 8'b11110000;     
    
  rx_en<=0;
 rx_uld<=0;
//  rx_in<=0;
 
    #20;
    reset <= 1;
    // #10;
    // ld_tx <= 1;   rx_uld<=1;
    // #10;
    // ld_tx <= 0;   rx_uld<=0;
    // #10;
    // wr_en <= 1;    rx_en<=1;
    // #120;
    // wr_en <= 0;    rx_en<=0;
    #500;
    $stop; 

end
initial begin
    $monitor(
        "Time=%0t tx=%b rx=%h tx_empty=%b rx_empty=%b",
        $time,
        tx_dout,
        rx_data,
        tx_empty,
        rx_empty
    );
end
endmodule 