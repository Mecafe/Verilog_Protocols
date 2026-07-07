`timescale 1ns / 1ps


//---------------------------------------------------------------------
// UART transmitter
//   wr_en    : pulse for one clock to load tx_din and start a frame
//   tx_empty : 1 = idle, ready to accept a new byte
//---------------------------------------------------------------------
module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_tick,
    input  wire       wr_en,
    input  wire [7:0] tx_din,
    output reg        tx_dout,
    output reg        tx_empty
);
    parameter IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;

    reg [1:0] p_s;
    reg [2:0] cnt;
    reg [7:0] tx_reg;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            p_s      <= IDLE;
            tx_dout  <= 1'b1;   // idle line is high
            tx_empty <= 1'b1;
            cnt  <= 0;
            tx_reg   <= 8'd0;
        end
          else begin if (p_s == IDLE && wr_en && tx_empty) begin
                 tx_reg   <= tx_din;
                 tx_empty <= 1'b0;
                 p_s      <= START;
                 end 
                 
         else if (tx_tick) begin // importantt: only advance state machine on tx_tick
                case (p_s)
                    IDLE: begin 
                        tx_dout <= 1'b1;
                    
                     end
        
                     START: begin
                        tx_dout <= 1'b0;      // start bit
                        cnt <= 0;
                        p_s     <= DATA;
                    end

                    DATA: begin
                        tx_dout <= tx_reg[cnt];
                        if (cnt == 3'd7)
                            p_s <= STOP;
                        else
                            cnt <= cnt + 1;
                    end

                    STOP: begin
                        tx_dout  <= 1'b1;     // stop bit
                        tx_empty <= 1'b1;     // ready for next byte
                        p_s      <= IDLE;
                    end

                    default: p_s <= IDLE;
                endcase
            end
    end
    end
endmodule


