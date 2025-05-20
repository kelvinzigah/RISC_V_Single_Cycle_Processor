module core_datapath (
    input logic clk,
    input logic reset,
    input logic [1:0] PCSrc,
    input logic [2:0] ResultSrc,
    input logic [2:0] ImmSrc,
    input logic RegWrite,
    input logic ALUSrc,
    input logic MemWrite,
    input logic [3:0] ALUControl,
    input  logic [31:0] Instruction,
    input logic [31:0] ReadData,

    output logic [31:0] WriteData,
    output logic [31:0] PC,
    output logic [31:0] ALUResult,  
    output logic ZeroFlag,
    output logic NegativeFlag,
    output logic CarryFlag,
    output logic OverflowFlag
	
);

// Signals
wire [31:0] PCNext;
wire [31:0] PCPlus4;
wire  [31:0] PCTarget;
wire  [31:0] ImmExt;
wire  [31:0] RegWriteData; //<= (Result)
wire  [31:0] RegData1, RegData2;
wire  [31:0] StoreData = RegData2;
wire  [31:0] SrcB;

assign WriteData = StoreData;


// PC Mux
PCNextMux PCMux (

    .PCSrc(PCSrc),
    .jalr_address(ALUResult),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),

    .PCNext(PCNext)
);

// PC + 4
PCPlus4 PCPlus4_inst (
//inputs
    .PC(PC),
//outputs
    .PCPlus4(PCPlus4)
);

// PC + offset
PCTarget PCTarget_inst (
    .ImmExt(ImmExt),
    .PC(PC),

    .PCTarget(PCTarget)
);


// PC 
PC PC_inst (
//inputs
    .PCNext(PCNext),
    .clk(clk),
    .reset(reset),
//outputs
    .PC(PC)
);


// Immediate Extender
ImmExt Extender (
    .ImmExt_In(Instruction[31:7]),
    .ImmSrc(ImmSrc),

    .ImmExt_Out(ImmExt)
);

// Register File
regfile registers (
    .clk(clk),
    .write_en(RegWrite),
    .reset(reset),
    .write_ad(Instruction[11:7]),
    .address1(Instruction[19:15]),
    .address2(Instruction[24:20]),
    .data_in(RegWriteData),

    .data_out1(RegData1), //<= Src A
    .data_out2(RegData2) 
);

// ALU SrcB Mux
ALUMux ALUMux_inst (
    .RegOperand(RegData2),
    .ImmExt(ImmExt),
    .ALUSrc(ALUSrc),

    .SrcB(SrcB)
);

// ALU
ALU ALU_inst (
    .input_A(RegData1),
    .input_B(SrcB),
    .ALU_Control(ALUControl),

    .result(ALUResult),
    .Zero_Flag(ZeroFlag),
    .Overflow_Flag(OverflowFlag),
    .Carry_Flag(CarryFlag),
    .Negative_Flag(NegativeFlag)
);


// Result Mux
ResultSrcMux ResultMux (
    .ResultSrc(ResultSrc),
    .ALUResult(ALUResult),
    .MemoryData(ReadData),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget), //AUIPC
    .ImmExt(ImmExt), //LUI instruction

    .RegWriteData(RegWriteData)
);



endmodule

