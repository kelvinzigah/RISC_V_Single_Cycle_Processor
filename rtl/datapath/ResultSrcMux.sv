module ResultSrcMux (

input logic [2:0] ResultSrc,
input logic [31:0] ALUResult,
input logic [31:0] MemoryData,
input logic [31:0] PCPlus4, //jal
input logic [31:0] ImmExt, //lui
input logic [31:0] PCTarget, //AUIPC

output logic [31:0] RegWriteData
);

always_comb
	begin
	  unique case(ResultSrc)
			3'b000: RegWriteData = ALUResult;
			3'b001: RegWriteData = MemoryData;
			3'b010: RegWriteData = PCPlus4;
			3'b011: RegWriteData = ImmExt;
			3'b100: RegWriteData = PCTarget;
			default: RegWriteData = 32'hxxxxxxxx;
		endcase
	end


endmodule
