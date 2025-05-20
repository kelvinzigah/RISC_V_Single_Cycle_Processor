`timescale 1ns / 1ps


module ALUMux_tb;

logic [31:0] RegOperand;
logic [31:0] ImmExt;
logic  ALUSrc;
logic [31:0] SrcB;

ALUMux ALUMuxdut(

.RegOperand(RegOperand),
.ImmExt(ImmExt),
.ALUSrc(ALUSrc),
.SrcB(SrcB)

);


initial begin


RegOperand = 32'h1234BEEF;
ImmExt = 32'h4321FEEB;
ALUSrc = 0;
#5;

RegOperand = 32'h10001000;
ImmExt = 32'h20002000;
ALUSrc = 1;


$monitor(" Register Operand = %h, Extend Output = %h, ALUSrc = %b, SrcB = %h" , RegOperand, ImmExt, ALUSrc, SrcB);

#50;
$finish;

end



endmodule
