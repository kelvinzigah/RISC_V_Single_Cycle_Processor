module single_core(
	input logic clk,
	input logic reset,
	input logic [31:0] Instruction,
	input logic [31:0] ReadData,

	output logic [31:0] PC,
	output logic [31:0] ALURes,
	output logic MemWrite,
	output logic [31:0] WriteData

);


//wires
wire ZeroFlag;
wire RegWrite;
wire ALUSrc;
wire [1:0] PCSrc;
wire [2:0] ALUControl;
wire [1:0] ResultSrc;
wire [2:0] ImmSrc;

wire [31:0] WritetoReg;


ControlUnit Control(

	.ZeroFlag(ZeroFlag),
	.op(Instruction[6:0]),
	.func7_5(Instruction[30]),
	.func3(Instruction[14:12]),

	.RegWrite(RegWrite),
	.ALUSrc(ALUSrc),
	.MemWrite(MemWrite),
	.PCSrc(PCSrc),
	.ALUcontrol(ALUControl),
	.ResultSrc(ResultSrc),
	.ImmSrc(ImmSrc)
);


core_datapath path(
	.clk(clk),
	.reset(reset),
	.PCSrc(PCSrc),
	.ResultSrc(ResultSrc),
	.ImmSrc(ImmSrc),
	.RegWrite(RegWrite),
	.ALUSrc(ALUSrc),
	.MemWrite(MemWrite),
	.ALUControl(ALUControl),
	.ALURes(ALURes),

	.PC(PC),
	.Instruction(Instruction),
	.WritetoReg(WritetoReg),
	.ZeroFlag(ZeroFlag)



);

endmodule