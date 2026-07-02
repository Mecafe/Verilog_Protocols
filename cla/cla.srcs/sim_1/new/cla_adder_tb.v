`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 23:35:22
// Design Name: 
// Module Name: cla_adder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cla_adder_tb( );

reg [3:0]a,b;
reg cin;wire [2:0]c;wire [4:0]sum;
 cla_adder cla1(a, b,cin, c,sum);
initial begin

a=4'd0;b=4'd0;cin=0;#10
a=4'd3;b=4'd3;cin=0;#10;
a=4'd6;b=4'd6;cin=0;#10;

$stop;



end

endmodule
