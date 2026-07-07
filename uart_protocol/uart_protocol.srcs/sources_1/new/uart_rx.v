`timescale 1ns/1ps
//---------------------------------------------------------------------
// UART receiver (16x oversampling)
//   rd_en     : pulse for one clock to acknowledge/clear rx_empty after reading rx_data
//   rx_empty  : 1 = no new data, 0 = rx_data holds a fresh unread byte
//---------------------------------------------------------------------
module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       rx_tick,
    input  wire       rx_in,
    input  wire       rd_en,
    output reg  [7:0] rx_data,
    output reg        rx_empty
);
    parameter IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;

    reg [1:0] p_s;
    reg [3:0] sample_cnt;
    reg [2:0] cnt;
    reg [7:0] rx_shift;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            p_s        <= IDLE;
            rx_data    <= 8'd0;
            rx_empty   <= 1'b1;   // nothing received yet
            sample_cnt <= 0;
            cnt    <= 0;
            rx_shift   <= 0;
        end else begin
            if (rd_en)
                rx_empty <= 1'b1;   // byte has been read, clear "ready" flag

            if (rx_tick) begin
                case (p_s)
                    IDLE: begin
                        sample_cnt <= 0;
                        if (rx_in == 1'b0)      // possible start bit
                            p_s <= START;
                    end

                    START: begin
                        if (sample_cnt == 4'd7) begin      // sample mid start-bit
                            if (rx_in == 1'b0) begin        // confirmed start bit
                                sample_cnt <= 0;
                                cnt    <= 0;
                                p_s        <= DATA;
                            end else begin
                                p_s <= IDLE;                 // false start, glitch
                            end
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                    DATA: begin
                        if (sample_cnt == 4'd15) begin
                            sample_cnt          <= 0;
                            rx_shift[cnt]    <= rx_in;   // sample mid data-bit
                            if (cnt == 3'd7)
                                p_s <= STOP;
                            else
                                cnt <= cnt + 1;
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                    STOP: begin
                        if (sample_cnt == 4'd15) begin
                            sample_cnt <= 0;
                            rx_data    <= rx_shift;
                            rx_empty   <= 1'b0;              // new byte ready
                            p_s        <= IDLE;
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                    default: p_s <= IDLE;
                endcase
            end
        end
    end
endmodule


