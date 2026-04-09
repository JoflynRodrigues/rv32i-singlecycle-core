`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2026 16:03:03
// Design Name: 
// Module Name: PC
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


module pc(

    input clk,
    input reset,
    input [31:0] pc_next,
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 0;
    else
        pc_out <= pc_next;
end

endmodule



