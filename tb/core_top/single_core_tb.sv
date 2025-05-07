

module single_core_tb;


//signals
	logic clk = 0;
	logic reset;
	logic [31:0] Instruction;
	logic [31:0] ReadData;

	logic [31:0] PC;
	logic [31:0] ALURes;
	logic MemWrite;
	logic [31:0] WriteData;


single_core coredut(
	.clk(clk),
	.reset(reset),
	.Instruction(Instruction),
	.ReadData(ReadData),

	.PC(PC),
	.ALURes(ALURes),
	.MemWrite(MemWrite),
	.WriteData(WriteData)

);

always #5 clk = ~clk;


 // Monitoring at every clock edge
    always @(posedge clk) begin
        $display("----------------------------------------------------");
        $display("Time        = %0t ns", $time);
        $display("PC          = %h", PC);
        $display("MemWrite = %b", MemWrite);
        $display("ALURes      = %h", ALURes);
        $display("WriteData  = %h", WriteData);
       
        $display("----------------------------------------------------");
    end

initial begin

	reset = 1;
	clk = 0;
	Instruction = 32'h00000000; 
	ReadData = 32'h00000000;
	#10;
	reset = 0;
	//Instruction = 32'h6AE01337; // LUI x6,0x6AE01000
	#10;
	Instruction = 32'h6AE013B7;   // LUI x7,0x6AE01000
	#10;
	//Instruction = 32'hDEADB437;   // LUI x8,0xDEADB000
	//#10;
	//Instruction = 32'h02830863;  // beq x6, x8, 24
	//#10;
	//Instruction = 32'h02730863;  // beq x6, x7, 24
	//#10;












#50;

$finish;

end

endmodule
