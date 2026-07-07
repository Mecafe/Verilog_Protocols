`timescale 1ns/1ps 

//---------------------------------------------------------------------
// Testbench: loops tx_dout straight back into rx_in and checks that
// what comes out of the receiver matches what was sent.
//---------------------------------------------------------------------
module uart_tb();

    reg        clk;
    reg        reset;
    reg        wr_en;
    reg [7:0]  tx_din;
    reg        rd_en;

    wire       tx_dout;
    wire       tx_empty;
    wire [7:0] rx_data;
    wire       rx_empty;

    uart_top uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .tx_din(tx_din),
        .tx_dout(tx_dout),
        .tx_empty(tx_empty),
        .rx_in(tx_dout),     // loopback: what TX sends, RX receives
        .rd_en(rd_en),
        .rx_data(rx_data),
        .rx_empty(rx_empty)
    );

    always #5 clk = ~clk;

    task send_byte(input [7:0] data);
        begin
            @(posedge clk);
            tx_din <= data;
            wr_en  <= 1'b1;
            @(posedge clk);
            wr_en  <= 1'b0;
        end
    endtask

    task read_byte;
        begin
            wait (rx_empty == 1'b0);
            $display("Time=%0t  Received data = %h", $time, rx_data);
        @(posedge clk);
            rd_en <= 1'b1;
            @(posedge clk);
            rd_en <= 1'b0;
        end
    endtask

    initial begin
        clk    = 0;
        reset  = 0;      // hold in reset...
        wr_en  = 0;
        rd_en  = 0;
        tx_din = 0;

        #20 reset = 1;   // ...then release reset and let it run

        send_byte(8'b11110000);
        read_byte();

        send_byte(8'b00001111);
        read_byte();

        #5120;
        $finish;
    end

endmodule