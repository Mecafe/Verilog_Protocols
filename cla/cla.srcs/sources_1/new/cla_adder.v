`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 23:23:31
// Design Name: 
// Module Name: cla_adder
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


module cla_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [2:0] c,
    output [4:0] sum
    );
wire [3:0]p,g;
    
    assign p[0]=a[0]^b[0];
    assign p[1]=a[1]^b[1];
    assign p[2]=a[2]^b[2];
    assign p[3]=a[3]^b[3];
    
    assign g[0]=a[0]&b[0];
    assign g[1]=a[1]&b[1];
    assign g[2]=a[2]&b[2];
    assign g[3]=a[3]&b[3];
    
    assign sum[0]=p[0]^cin;
    assign sum[1]=p[1]^c[0];
    assign sum[2]=p[2]^c[1];
    assign sum[3]=p[3]^c[2];
    
    
    assign c[0]=(p[0]&c[0])|g[0];
    assign c[1]=(p[1]&c[1])|g[1];
    assign c[2]=(p[2]&c[2])|g[2];
    assign sum[4]=(p[3]&c[3])|g[3];
    
endmodule
