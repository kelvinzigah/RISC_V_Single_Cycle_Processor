module single_core(
	input logic clk,
	input logic reset,
	input logic [31:0] Instruction,
	input logic [31:0] ReadData,

	output logic [31:0] PC,
	output logic [31:0] ALURes,
	output logic MemWrite,
	output logic [31:0] WriteData,
	
	output logic DataType,
	output logic [1:0] DataSize

);


//wires
wire ZeroFlag;
wire NegativeFlag;
wire CarryFlag;
wire OverflowFlag;
wire RegWrite;
wire ALUSrc;
wire [1:0] PCSrc;
wire [3:0] ALUControl;
wire [2:0] ResultSrc;
wire [2:0] ImmSrc;
//wire DataType;
//wire [1:0] DataSize;




ControlUnit Control(

	.ZeroFlag(ZeroFlag),
	.NegativeFlag(NegativeFlag),
	.CarryFlag(CarryFlag),
	.OverflowFlag(OverflowFlag),
	.op(Instruction[6:0]),
	.func7_5(Instruction[30]),
	.func3(Instruction[14:12]),

	.DataType(DataType),
	.DataSize(DataSize),

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
	.Instruction(Instruction),
	.ReadData(ReadData),
	
	.ALUResult(ALURes),
	.PC(PC),
	.WriteData(WriteData),
	.ZeroFlag(ZeroFlag),
	.NegativeFlag(NegativeFlag),
	.CarryFlag(CarryFlag),
	.OverflowFlag(OverflowFlag)



);

endmodule