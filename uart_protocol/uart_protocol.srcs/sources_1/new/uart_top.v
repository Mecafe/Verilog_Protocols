`timescale 1ns/1ps

module uart_top(clk,reset,rx_in,rx_en,rx_uld,rx_data,rx_empty,wr_en,tx_din,ld_tx,tx_dout,tx_empty);


//INPUTS
input clk;input reset;input wr_en;input [7:0]tx_din;input ld_tx;
//OUTPUTS
output  tx_dout;output  tx_empty;



input rx_in;input rx_en;input rx_uld;
output [7:0]rx_data;output rx_empty;    




uart_tx tx1(clk,reset,wr_en,tx_din,ld_tx,tx_dout,tx_empty); 
uart_rx rx1(clk,reset,rx_in,rx_en,rx_uld,rx_data,rx_empty);   
 





endmodule