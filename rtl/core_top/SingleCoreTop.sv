module SingleCoreTop(
	input logic clk,
	input logic reset,

//outputs for testing
	output logic [31:0] WriteData,
	output logic [31:0] DataAddress,
	output logic MemWrite,
	output logic [31:0] PC //<- testing only
	
);

wire [31:0] PCinternal;  //was PC
wire [31:0] Instruction;
wire [31:0] ReadData;
wire [1:0] DataSize;
wire DataType;

assign PC = PCinternal;

single_core Core(
	.clk(clk),
	.reset(reset),
	.Instruction(Instruction),
	.ReadData(ReadData),
	
	.PC(PCinternal),
	.ALURes(DataAddress),
	.MemWrite(MemWrite),
	.WriteData(WriteData),

	.DataSize(DataSize),
	.DataType(DataType)
);

instruction_cache IM(
	.address_input(PCinternal),

	.data_output(Instruction)
);

datamem DM(
	.clk(clk),
	.reset(reset),
	.datatype(DataType),
	.datasize(DataSize),
	.WriteEn(MemWrite),
	.address(DataAddress),
	.datain(WriteData),

	.dataout(ReadData)
	
);

endmodule


