module PCNextMux(

input logic [1:0] PCSrc,
input logic [31:0] jalr_address, //aka alu_out/og PC+4
input logic [31:0] PCPlus4,
input logic [31:0] PCTarget,

output logic [31:0] PCNext
);


always_comb
begin
	case(PCSrc)
		2'b00 : PCNext = PCPlus4;
		2'b01 : PCNext = PCTarget;
		2'b10 : PCNext = jalr_address;
		default: PCNext = 32'hxxxxxxxx;
	endcase

end
endmodule

