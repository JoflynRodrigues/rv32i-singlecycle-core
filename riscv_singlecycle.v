`timescale 1ns / 1ps
module riscv_singlecycle(
    input clk,
    input reset
    );
    
//pc
wire [31:0] PC;
wire [31:0] PC_next;

pc PC_reg(
    .clk(clk),
    .reset(reset),
    .pc_next(PC_next),
    .pc_out(PC)
);
//INstruction Memory
reg[31:0]imem[0:255];
wire [31:0]instr;
assign instr=imem[PC[9:2]];

//decode

wire[4:0]rs1=instr[19:15];
wire[4:0]rs2=instr[24:20];
wire[4:0]rd=instr[11:7];

//REgister file
wire[31:0]reg_data1,reg_data2;
wire[31:0]write_data;
wire Regwrite;
regfile rf(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(write_data),
    .re(Regwrite),
    .rd1(reg_data1),
    .rd2(reg_data2)
    );
//immediate generator

wire[31:0]immi;
immediate ig(
    .instr(instr),
    .immi(immi)
    );
    
//control unit
wire Memread,Memwrite,ALUsrc,MemToReg, Branch,Jump,Jalr;
wire[3:0]ALUCtrl;

control_unit ctrl(
    .instr(instr),
    .Regwrite(Regwrite),
    .Memread(Memread),
    .Memwrite(Memwrite),
    .ALUsrc(ALUsrc),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl),
    .Branch(Branch),
    .Jump(Jump),
    .Jalr(Jalr)
   
    );
    
//ALU
wire[31:0]alu_in;
wire[31:0]alu_result;
wire zero;
wire lt;
assign alu_in=ALUsrc?immi:reg_data2;
alu ALU(
    .a(reg_data1),
    .b(alu_in),
    .alu_cntrl(ALUCtrl),
    .result(alu_result),
    .zero(zero),
    .lt(lt)
    );
    
integer i;
initial begin
    for (i = 0; i < 256; i = i + 1)
        dmem[i] = 0;
end
//data memory
reg[31:0]dmem[0:255];
wire[31:0]mem_read_data;
assign mem_read_data=dmem[alu_result[9:2]];
always @(posedge clk)begin
    if(Memwrite)
        dmem[alu_result[9:2]]<=reg_data2;
end

//write back
assign write_data =
        Jump  ? PC + 4 :
        Jalr  ? PC + 4 :
        (instr[6:0] == 7'b0110111) ? immi :        // LUI
        (instr[6:0] == 7'b0010111) ? PC + immi :   // AUIPC
        MemToReg ? mem_read_data :
        alu_result;

    // BRANCH LOGIC
wire take_branch;
assign take_branch = Branch & (
                        (instr[14:12] == 3'b000 && zero) ||     // beq
                        (instr[14:12] == 3'b001 && !zero) ||    // bne
                        (instr[14:12] == 3'b100 && lt)   ||     // blt
                        (instr[14:12] == 3'b101 && !lt)         // bge
                     );


// NEXT PC LOGIC
assign PC_next =
        Jump  ? PC + immi :
        Jalr  ? (reg_data1 + immi) & ~1 :
        take_branch ? PC + immi :
        PC + 4;

endmodule

