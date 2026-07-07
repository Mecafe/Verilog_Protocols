
`timescale 1ns / 1ps
//=====================================================================
// Simple UART: baud generator + transmitter + receiver + top + testbench
// Active-low asynchronous reset throughout (reset = 0 means "in reset").
//=====================================================================

//---------------------------------------------------------------------
// Baud generator
//   tx_tick : pulses once per bit period      (used by TX)
//   rx_tick : pulses 16x per bit period        (used by RX for oversampling)
// DIV controls how fast rx_tick fires (clk / DIV). Kept small here so
// simulation runs quickly; make DIV bigger for a realistic baud rate.
//---------------------------------------------------------------------
module baud_gen  (
    input  wire clk,
    input  wire reset,
    output reg  rx_tick,
    output reg  tx_tick
);
    reg [2:0] div_cnt;
    reg [3:0] rx_cnt;   // counts 16 rx_ticks make one tx_tick

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            div_cnt  <= 0;
            rx_cnt  <= 0;
            rx_tick  <= 0;
            tx_tick  <= 0;
        end else begin
            // generate rx_tick every DIV clocks
            if (div_cnt == 2'd3) begin
                div_cnt <= 0;
                rx_tick <= 1'b1;
            end else begin
                div_cnt <= div_cnt + 1;
                rx_tick <= 1'b0;
            end

            // generate tx_tick every 16 rx_ticks
            if (rx_tick) begin
                if (rx_cnt == 4'd15) begin
                    rx_cnt <= 0;
                    tx_tick <= 1'b1;
                end else begin
                    rx_cnt <= rx_cnt + 1;
                    tx_tick <= 1'b0;
                end
            end else begin
                tx_tick <= 1'b0;
            end
        end
    end
endmodule
