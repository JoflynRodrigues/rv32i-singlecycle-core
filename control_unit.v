`timescale 1ns / 1ps
module control_unit(
    input[31:0]instr,
    output reg Regwrite,Memread,Memwrite,ALUsrc,MemToReg,
    output reg[3:0]ALUCtrl,
    output reg Branch,
    output reg Jump,
    output reg Jalr

    );
 wire[6:0]opcode=instr[6:0];
 wire[2:0]funct3=instr[14:12];
 wire[6:0]funct7=instr[31:25];
 
 
 always @(*)begin
    //deafults
    Regwrite=0;Memread=0;Memwrite=0;Branch =0; Jump= 0;
    Jalr = 0;
    ALUsrc=0;MemToReg=0;ALUCtrl=4'b0000;
    
    case(opcode)
        7'b0110011:begin //R-type
            Regwrite=1;
            case({funct7,funct3})
               10'b0000000_000: ALUCtrl = 4'b0000; // add
                10'b0100000_000: ALUCtrl = 4'b0001; // sub
                10'b0000000_100: ALUCtrl = 4'b0010; // xor
                10'b0000000_111: ALUCtrl = 4'b0011; // and
                10'b0000000_110: ALUCtrl = 4'b0100; // or
                10'b0000000_001: ALUCtrl = 4'b0101; // sll
                10'b0000000_101: ALUCtrl = 4'b0110; // srl
                10'b0100000_101: ALUCtrl = 4'b0111; // sra
                10'b0000000_010: ALUCtrl = 4'b1000; // slt
            endcase
        end
        7'b0010011:begin  //ADDI
            Regwrite=1;
            ALUsrc=1;
            case (funct3)
                3'b000: ALUCtrl = 4'b0000; // addi
                3'b100: ALUCtrl = 4'b0010; // xori
                3'b010: ALUCtrl = 4'b1000; // slti
                3'b001: ALUCtrl = 4'b0101; // slli
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        ALUCtrl = 4'b0110; // srli
                    else
                        ALUCtrl = 4'b0111; // srai
                end
            endcase
        end
        
        7'b0000011:begin  //LW
           Regwrite=1;
           Memread=1;
           ALUsrc=1;
           MemToReg=1;
        end
        
        7'b0100011:begin  //SW
            Memwrite=1;
            ALUsrc=1;
        end
        7'b1100011: begin // BEQ
            Branch = 1;
            ALUCtrl = 4'b0001; // SUB
        end    
        // ================= JAL =================
        7'b1101111: begin
            Regwrite = 1;
            Jump = 1;
        end

        // ================= JALR =================
        7'b1100111: begin
            Regwrite = 1;
            ALUsrc = 1;
            Jalr = 1;
        end

        // ================= LUI =================
        7'b0110111: begin
            Regwrite = 1;
        end

        // ================= AUIPC =================
        7'b0010111: begin
            Regwrite = 1;
        end

     endcase
     
   end


endmodule
