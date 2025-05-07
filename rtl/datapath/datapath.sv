module core_datapath (
    input logic clk,
    input logic reset,
    input logic [1:0] PCSrc,
    input logic [1:0] ResultSrc,
    input logic [2:0] ImmSrc,
    input logic RegWrite,
    input logic ALUSrc,
    input logic MemWrite,
    input logic [2:0] ALUControl,
    input logic [31:0] ALURes,  //<== for testing only
    
     

    //output logic [31:0] WriteData,
    	output logic [31:0] PC,
   	output  logic [31:0] Instruction,  //<== for testing only
	 
	output logic [31:0] WritetoReg,  //<== for testing only 
	//output logic [31:0] ALURes,  //<== for testing only 
    	output logic ZeroFlag
	
);

// Signals
wire [31:0] PCNext;
wire [31:0] PCPlus4;
wire  [31:0] PCTarget;
wire  [31:0] ALUResult;
wire  [31:0] ImmExt;
wire  [31:0] RegWriteData;
wire  [31:0] RegData1, RegData2;
wire  [31:0] SrcB;
wire [31:0] ReadData;
wire [31:0] Instr;


//testing assignments to be deleted later (remove these signals from the testbench and this device's portmap)
assign Instruction = Instr;
assign ALURes = ALUResult;
assign WritetoReg = RegWriteData;



// PC Mux
PCNextMux PCMux (
//inputs
    .PCSrc(PCSrc),
    .jalr_address(ALUResult),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),
//outputs
    .PCNext(PCNext)
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

// Instruction Memory
instruction_cache IM (

    .address_input(PC), 

    .data_output(Instr)
);

// Immediate Extender
ImmExt Extender (
    .ImmExt_In(Instr[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt_Out(ImmExt)
);

// Register File
regfile registers (
    .clk(clk),
    .write_en(RegWrite),
    .reset(reset),
    .write_ad(Instr[11:7]),
    .address1(Instr[19:15]),
    .address2(Instr[24:20]),
    .data_in(RegWriteData),
    .data_out1(RegData1),
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
    .Zero_Flag(ZeroFlag)
);

// Data Memory
datamem DM (
    .clk(clk),
    .WriteEn(MemWrite),
    .address(ALUResult),
    .datain(RegData2),
    .dataout(ReadData)
);

// Result Mux
ResultSrcMux ResultMux (
    .ResultSrc(ResultSrc),
    .ALUResult(ALUResult),
    .MemoryData(ReadData),
    .PCPlus4(PCPlus4),
    .ImmExt(ImmExt),
    .RegWriteData(RegWriteData)
);



endmodule

