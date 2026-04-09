`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2026 12:42:29
// Design Name: 
// Module Name: immediate
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


module immediate(
    input[31:0]instr,
    output reg[31:0]immi
    );
wire[6:0]opcode=instr[6:0];
always @(*)begin
    case(opcode)
         // I-Type (addi, xori, slti, loads, jalr)
        7'b0010011,
        7'b0000011,
        7'b1100111:
            immi = {{20{instr[31]}}, instr[31:20]};

        // S-Type (store)
        7'b0100011:
            immi = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        // B-Type (branch)
        7'b1100011:
            immi = {{19{instr[31]}},
                   instr[31],
                   instr[7],
                   instr[30:25],
                   instr[11:8],
                   1'b0};

        // U-Type (lui, auipc)
        7'b0110111,
        7'b0010111:
            immi = {instr[31:12], 12'b0};

        // J-Type (jal)
        7'b1101111:
            immi = {{11{instr[31]}},
                   instr[31],
                   instr[19:12],
                   instr[20],
                   instr[30:21],
                   1'b0};

        default:immi=0;
    endcase
end
endmodule
