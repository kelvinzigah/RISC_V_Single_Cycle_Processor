module ControlUnit (
input logic ZeroFlag,
input logic [6:0] op,
input  logic func7_5,
input  logic [2:0] func3,


output logic RegWrite,
output logic ALUSrc,
output logic MemWrite,
output logic [1:0] PCSrc,
output logic [2:0] ALUcontrol,
output logic [1:0] ResultSrc, 
 output logic [2:0] ImmSrc

);

// signals
logic Branch;
logic [1:0] ALUop;
logic Jump;

//creating components

 MainDecoder MainDecoder(
.ZeroFlag(ZeroFlag), 
.op(op),

.RegWrite(RegWrite),
.ALUSrc(ALUSrc),
.MemWrite(MemWrite),
.Branch(Branch), 
.ResultSrc(ResultSrc),
.ALUop(ALUop), 
.PCSrc(PCSrc),
.Jump(Jump),
.ImmSrc(ImmSrc)
);


ALUDecoder ALUDecoder(
.op(op),
.func7_5(func7_5),
.func3(func3),
.ALUop(ALUop),

.ALUcontrol(ALUcontrol)
);


//testing
always @(*) begin
	$monitor ( " Control Unit Inputs :  1. Zeroflag = %h , 2. opcode = %h , 3. 5th bit of function 7 = %h , function 3 = %h ", ZeroFlag, op, func7_5, func3);
	$monitor ( " Control Unit outputs : Regwrite = %h , ALUSrc = %h , MemWrite = %h , ResultSrc = %h , ALUcontrol = %h, PCSrc = %h , ImmSrc = %h ", RegWrite, ALUSrc, MemWrite, ResultSrc, ALUcontrol, PCSrc, ImmSrc);
end

endmodule
