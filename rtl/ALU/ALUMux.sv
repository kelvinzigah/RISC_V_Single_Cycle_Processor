module ALUMux (
input logic [31:0] RegOperand,
input logic [31:0] ImmExt,
input logic ALUSrc,

output logic [31:0] SrcB

);

assign SrcB = (ALUSrc) ? ImmExt : RegOperand;

endmodule
