module SingleCoreTop(
	input logic clk,
	input logic reset,

//outputs for testing
	output logic [31:0] WriteData,
	output logic [31:0] DataAddress,
	output logic MemWrite

);

wire [31:0] PC;
wire [31:0] Instruction;
wire [31:0] ReadData;

single_core Core(
	.clk(clk),
	.reset(reset),
	.Instruction(Instruction),
	.ReadData(ReadData),
	
	.PC(PC),
	.ALURes(DataAddress),
	.MemWrite(MemWrite),
	.WriteData(WriteData)
);

instruction_cache IM(
	.address_input(PC),

	.data_output(Instruction)
);

datamem DM(
	.clk(clk),
	.WriteEn(MemWrite),
	.address(DataAddress),
	.datain(WriteData),

	.dataout(ReadData)
	
);

endmodule


