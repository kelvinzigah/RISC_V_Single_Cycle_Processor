module datapath_tb;

//note: some instructions in the instruction memory were temporarily changed to test the datapath


logic clk = 0;
logic reset;
logic [1:0] PCSrc;
logic [1:0] ResultSrc;
logic [2:0] ImmSrc;
logic RegWrite;
logic MemWrite;
logic [2:0] ALUControl;
logic ALUSrc;
wire [31:0] ALURes;
wire [31:0] Instruction;
logic [31:0] PC;
wire [31:0] WritetoRegister;
logic ZeroFlag;




core_datapath datapath_DUT(
.clk(clk), 
.reset(reset), 
.PCSrc(PCSrc),
.ResultSrc(ResultSrc),
.ImmSrc(ImmSrc),
.RegWrite(RegWrite),
.ALUSrc(ALUSrc),
.MemWrite(MemWrite),
.ALUControl(ALUControl),
.Instruction(Instruction),
.PC(PC),
.WritetoReg(WritetoRegister),
.ZeroFlag(ZeroFlag),
.ALURes(ALURes)

);



always #5 clk = ~clk;


 // Monitoring at every clock edge
    always @(posedge clk) begin
        $display("----------------------------------------------------");
        $display("Time        = %0t ns", $time);
        $display("PC          = %h", PC);
        $display("Instruction = %h", Instruction);
        $display("ALURes      = %h", ALURes);
        $display("WritetoReg  = %h", WritetoRegister);
        $display("ZeroFlag    = %b", ZeroFlag);
        $display("----------------------------------------------------");
    end


initial begin 

$display("-------------------------TEST 1: Cycle Through instruction Memory -------------------------");


// 1) reset + fetch
    clk         = 0;
    reset       = 1;
    PCSrc       = 2'b00;  
    ResultSrc   = 2'b00;
    ImmSrc      = 3'b000;
    RegWrite    = 0;
    ALUSrc      = 0;
    MemWrite    = 0;
    ALUControl  = 3'b000;

    #10;              
    reset = 0; 

   #212; // 210 cause we have 21 instructions and each instruction happens every posedge (10ns x 21 instructions), 2 cause we want signals to settle

//instructions changed: None
$display("-------------------------END TEST 1-----------------------------------");


$display("------------------------ TEST 2 : JALR Instruction ----------------------");
	
    // 1) reset + fetch
    clk         = 0;
    reset       = 1;
    PCSrc       = 2'b00;  
    ResultSrc   = 2'b00;
    ImmSrc      = 3'b000;
    RegWrite    = 0;
    ALUSrc      = 0;
    MemWrite    = 0;
    ALUControl  = 3'b000;

    #10;              
    reset = 0;        

    
    // 2) Step 1: fetch the JALR instruction at mem location given by pc + 4 when pc = 0
    //--------------------------------------------------------------------------------
    
    @(posedge clk); #6;
	
    $display("After fetch cycle: PC=%0h  Instr=%0h", PC, Instruction);
    // (Instruction should now be JALR at address 4)

    //--------------------------------------------------------------------------------
    // 3) Step 2: apply JALR control signals so ALU computes x0+imm
    //    - We assume that at IM[4] you put a JALR rd=x0, rs1=x0, imm=0x38
    //    - ALUSrc=1 selects the immediate from ImmExt
    //    - ImmSrc=3'b000 selects I-type sign-extension
    //    - ALUControl=3'b000 => add
    //    - PCSrc=2'b10 => select ALURes for next PC
    //--------------------------------------------------------------------------------
    PCSrc      = 2'b10;
    ALUSrc     = 1;
    ImmSrc     = 3'b000;
    ALUControl = 3'b000;
    RegWrite   = 0;   // writes go to x0, so ignored
    MemWrite   = 0;

    @(posedge clk);
    #1;  // let outputs settle

    $display("After JALR cycle:   PC=%0h  Instr=%0h  ALURes=%0h", 
              PC, Instruction, ALURes);
    // Expect PC == 38


	
//Instructions changed:  
//this : 32'h00000004: data_output =  32'h00C00193; addi x3,x0,12 became this :  32'h00000004: data_output = 32'h038000E7; //jalr pc -> 0x38
$display("---------------------------- END OF TEST 2 ---------------------- ");

$display("-------------------------TEST 3: Branch Instruction (BEQ) - branch  -----------------");

	// 1) reset + fetch
    clk         = 0;
    reset       = 1; 
    PCSrc       = 2'b00;  
    ResultSrc   = 2'b00;
    ImmSrc      = 3'b000;
    RegWrite    = 0;
    ALUSrc      = 0;
    MemWrite    = 0;
    ALUControl  = 3'b000;

    #10;              
    reset = 0;

	//2) JALR to the branch instruction at mem location given by pc + 4 when pc = 0	
	@(posedge clk); #6;
	
    $display("After fetch cycle: PC=%0h  Instr=%0h", PC, Instruction);
    // (Instruction should now be JALR at address 4)
  PCSrc      = 2'b10;
    ALUSrc     = 1;
    ImmSrc     = 3'b000;
    ALUControl = 3'b000;
    RegWrite   = 0;   // writes go to x0, so ignored
    MemWrite   = 0;

    @(posedge clk);
    #1;  // let outputs settle

    $display("After JALR cycle:   PC=%0h  Instr=%0h  ALURes=%0h", 
              PC, Instruction, ALURes);
    // Expect PC == 20

	//3) beq loaded into PC so assign beq signals
	PCSrc = 2'b01;
	MemWrite = 0;
	ALUControl = 3'b001;
	ALUSrc = 0;
	ImmSrc = 3'b010;
	RegWrite = 0;

	@(posedge clk);

	//4) check if PC = 8
	#2; //lets outputs settle
	$display("After BEQ cycle:   PC=%0h  Instr=%0h  ALURes=%0h", 
              PC, Instruction, ALURes);
    // Expect PC == 8

//Instructions changed:  
//this : 32'h00000004: data_output =  32'h00C00193; addi x3,x0,12 became this :  32'h00000004: data_output = 32'h02000067; //jalr pc -> 0x20
$display("------------------- END TEST 3 ----------------------------");

$display("---------------------TEST 4 : LUI Instruction -----------");

	
	// 1) reset + fetch
    clk         = 0;
    reset       = 1; 
    PCSrc       = 2'b00;  
    ResultSrc   = 2'b00;
    ImmSrc      = 3'b000;
    RegWrite    = 0;
    ALUSrc      = 0;
    MemWrite    = 0;
    ALUControl  = 3'b000;

    #10;              
    reset = 0;



	//2)LUI instruction at mem location given by pc + 4 when pc = 0	
	@(posedge clk); #6;
	
    $display("After fetch cycle: PC=%0h  Instr=%0h", PC, Instruction);
    // (Instruction should now be LUI at address 4)

	//3) Set LUI control signals	
	ImmSrc = 3'b011;
	RegWrite = 1;
	ResultSrc = 2'b11;
	ALUSrc      = 0;
   	 MemWrite    = 0;
   	 ALUControl  = 3'b000;
	 #2;
//4) Show results,
	$display("WritetoRegister after Instruction : %h ", WritetoRegister);
//Expected: Register 6 gets 6ae01000
//note: A print statement was added in the regfile to see if the right register got the right value

//Instructions changed:  
//this : 32'h00000004: data_output =  32'h00C00193; addi x3,x0,12 became this :  32'h00000004: data_output = 32'h6AE01337; // LUI x6,0x6AE01000


$display(" -----------------------END TEST 4------------------------------");

$display("--------------------------TEST 5: LW AND SW------------------");


//1. Reset; copy from previous cases

	// 1) reset + fetch
    clk         = 0;
    reset       = 1; 
    PCSrc       = 2'b00;  
    ResultSrc   = 2'b00;
    ImmSrc      = 3'b000;
    RegWrite    = 0;
    ALUSrc      = 0;
    MemWrite    = 0;
    ALUControl  = 3'b000;

    #10;              
    reset = 0;
//2. JALR to 0x34 where sw instruction is and check if the PC is at that value , replace the current jalr instruction with this: 32'h03400067

	
    @(posedge clk); #6;
	
    $display("After fetch cycle: PC=%0h  Instr=%0h", PC, Instruction);
    // (Instruction should now be JALR at address 4)

	PCSrc      = 2'b10;
    ALUSrc     = 1;
    ImmSrc     = 3'b000;
    ALUControl = 3'b000;
    RegWrite   = 0;   
    MemWrite   = 0;

    @(posedge clk);
    #1;  // let outputs settle


//3. Set the control signals for the SW instruction (including PC + 4) and observe the value of the register

	//SW signals
	PCSrc = 2'b00;
	MemWrite = 1;
	ALUControl = 3'b000;
	ALUSrc = 1;
	ImmSrc = 3'b001;
	RegWrite = 0;

	@(posedge clk);
	$display("Data written to memory after sw: %h. PC = %h. Instruction = %h  ", ALURes, PC, Instruction);
	#2;
	//expected: memory address 0x2c (44) gets 0xDEADBEEA


 	//now pc is at the lw instruction
	//set the lw signals
	ResultSrc = 2'b01;
	MemWrite = 0;
	ALUControl = 3'b000;
	ALUSrc = 1;
	ImmSrc = 3'b000;
	RegWrite = 1;
	@(posedge clk);
	//expected: register 0x1d (29) gets 0xDEADBEEA stored at memory address 0x2c

//note: print statement and testcases added in datamem and/or regfile for testing
//instructions changed: 
//this : 
//	32'h00000004: data_output =  32'h6AE01337; // LUI x6,0x6AE01000 => 32'h00000004: data_output =  32'h03400067; //JALR pc -> 0x34
//	 32'h00000034: data_output = 32'h0471AA23; // sw x7,84(x3) => 32'h00000034: data_output = 32'h02702623;  // sw x7,44(x0)
//	32'h00000038: data_output = 32'h06002103; // lw x2,96(x0) =>   32'h00000038: data_output = 32'h02C02E83; // lw x29,44(x0)

	$display("-------------------------------END Test 5 -----------------------------------");



	

	$finish;
	
end



 	

endmodule
