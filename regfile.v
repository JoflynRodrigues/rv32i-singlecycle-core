`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2026 11:50:25
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input [4:0]rs1,rs2,rd,
    input [31:0]wd,
    input re,
    output [31:0]rd1,rd2
    );
   
reg [31:0] regs[0:31];
integer i;

    // Initialize registers to 0
initial begin
    for (i = 0; i < 32; i = i + 1)
        regs[i] = 0;
end

//read
assign rd1 = (rs1 == 0) ? 32'b0 : regs[rs1];
assign rd2 = (rs2 == 0) ? 32'b0 : regs[rs2];

 
//write
always @(posedge clk) begin
    if (re && rd !=0)
       regs[rd]<=wd;
end
endmodule
