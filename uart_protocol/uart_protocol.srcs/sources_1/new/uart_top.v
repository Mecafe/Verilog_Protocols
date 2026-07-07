`timescale 1ns/1ps

//---------------------------------------------------------------------
// Top level
//---------------------------------------------------------------------
module uart_top (
    input  wire       clk,
    input  wire       reset,
    input  wire       wr_en,
    input  wire [7:0] tx_din,
    output wire       tx_dout,
    output wire       tx_empty,
    input  wire       rx_in,
    input  wire       rd_en,
    output wire [7:0] rx_data,
    output wire       rx_empty
);
    wire tx_tick, rx_tick;

    baud_gen  b1 (
        .clk(clk), .reset(reset),
        .rx_tick(rx_tick), .tx_tick(tx_tick)
    );

    uart_tx tx1 (
        .clk(clk), .reset(reset), .tx_tick(tx_tick),
        .wr_en(wr_en), .tx_din(tx_din),
        .tx_dout(tx_dout), .tx_empty(tx_empty)
    );

    uart_rx rx1 (
        .clk(clk), .reset(reset), .rx_tick(rx_tick),
        .rx_in(rx_in), .rd_en(rd_en),
        .rx_data(rx_data), .rx_empty(rx_empty)
    );
endmodule
 