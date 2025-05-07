module MainDecoder( 
input logic ZeroFlag, 
input logic [6:0] op ,

output logic RegWrite, 
output logic ALUSrc,
output logic MemWrite, 
output logic Branch,
output logic Jump, 
output logic [1:0] ResultSrc, 
output logic [1:0] PCSrc,
output logic [1:0] ALUop, 
output logic [2:0] ImmSrc

);



 //input logic [6:0] op, input logic ZeroFlag,
//output logic RegWrite, ALUSrc, MemWrite, Branch, Jump, PCSrc
//output logic [1:0]  ResultSrc, AluOp, output logic [2:0] ImmSrc

logic [11:0] maincontrol;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch , ALUop, Jump} = maincontrol;

logic [1:0] PCSrc_internal;


always_comb 
begin
	case(op)
		//op = RegWrite(1)_ImmSrc(3)_AluSrc(1)_MemWrite(1)_ResultSrc(2)_Branch(1)_AluOp(2)_Jump(1)
	
	
		7'b0000011: maincontrol = 12'b1_000_1_0_01_0_00_0; //lw
		7'b0100011: maincontrol = 12'b0_001_1_1_00_0_00_0; //sw Result Src unused; xx=>00
		7'b0110011: maincontrol = 12'b1_000_0_0_00_0_10_0; //R-type ImmSrc unused; xxx=>000
		7'b1100011: maincontrol = 12'b0_010_0_0_00_1_01_0; //B-type Result Src unused; xx=>00
		7'b0010011: maincontrol = 12'b1_000_1_0_00_0_10_0; //I-type Alu
		7'b1101111: maincontrol = 12'b1_100_0_0_10_0_00_1; //jal ALuSrc, Aluop unused : x => 0 , xx=> 00
		7'b1100111: maincontrol = 12'b1_000_1_0_10_0_00_1; //jalr connect alu result to pc
		7'b0110111: maincontrol = 12'b1_011_0_0_11_0_00_0; //lui: increase range of resultsrc-mux and connect extend unit to it in datapath ALuSrc, Aluop unused : x => 0 , xx=> 00
		7'b0000000: maincontrol = 12'b0_000_0_0_00_0_00_0;//reset
		default : maincontrol = 12'b0_000_0_0_00_0_00_0;
	
	endcase

 //PCSRC
	if(op == 7'b1100111 && Jump ) begin //jalr begin
		PCSrc_internal = 2'b10; // PC <= ALU_out
	end else if (Jump) begin //jal
		PCSrc_internal = 2'b01; //PC <= PC + offset
	end else if (Branch && ZeroFlag) begin//normal PCSrc logic
		PCSrc_internal = 2'b01; //PC <= PC + offset
	end else begin
		PCSrc_internal = 2'b00; //PC <= PC + 4
	end

end

assign PCSrc = PCSrc_internal;

endmodule
