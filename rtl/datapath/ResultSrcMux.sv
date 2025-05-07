module ResultSrcMux (

input logic [1:0] ResultSrc,
input logic [31:0] ALUResult,
input logic [31:0] MemoryData,
input logic [31:0] PCPlus4, //jal
input logic [31:0] ImmExt, //lui

output logic [31:0] RegWriteData
);

always_comb
	begin
		case(ResultSrc)
			2'b00: RegWriteData = ALUResult;
			2'b01: RegWriteData = MemoryData;
			2'b10: RegWriteData = PCPlus4;
			2'b11: RegWriteData = ImmExt;
			default: RegWriteData = 32'hxxxxxxxx;
		endcase
	end


endmodule
