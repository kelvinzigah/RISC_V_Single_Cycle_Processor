

module single_core_tb;


//signals
	logic clk = 0;
	logic reset;
	logic [31:0] Instruction;
	logic [31:0] ReadData; //<= read from mem(output)

	logic [31:0] PC;
	logic [31:0] ALURes;
	logic MemWrite;
	logic [31:0] WriteData; //<= write to mem(input)
	logic DataType;
	logic [1:0] DataSize;


single_core coredut(
	.clk(clk),
	.reset(reset),
	.Instruction(Instruction),
	.ReadData(ReadData),

	.PC(PC),
	.ALURes(ALURes),
	.MemWrite(MemWrite),
	.WriteData(WriteData),
	.DataType(DataType),
	.DataSize(DataSize)
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
	Instruction = 32'h00080237; // LUI x4, 0x00000080 
	#10;
	Instruction = 32'h06401423; //SB x4, 0x34(x0)
	#10;
	Instruction = 32'h03404283; //LBU x5, 0x34(x0)
	#10;











#50;

$finish;

end

endmodule
