`timescale 1ns / 1ps

module ALU_TB ;
  

  
  //declaring signals
  logic signed [31:0] input_A , input_B, result;
  logic [2:0] ALU_Control;
  logic Zero_Flag;
  logic [31:0] ImmExt, RegData;
	
  logic ALUSrc;
  
  //ALUMUX
   ALUMux Muxdut(
	.RegOperand(RegData), 
	.ImmExt(ImmExt), 
	.ALUSrc(ALUSrc), 
	.SrcB(input_B)
);
  
  //instantiate ALU
  ALU  ALU_ut( 
.input_A(input_A), 
.input_B(input_B), 
.result(result) , 
.ALU_Control(ALU_Control), 
.Zero_Flag(Zero_Flag)
  );
  

  
  
  task check_result(input logic signed [31:0] expected);
    if(result !== expected) begin
      $display(" FAIL : ALU_Control = %b , input_A = %h , input_B = %h | Expected = %h , Returned = %h " , ALU_Control, input_A , input_B, expected, result);
    end
    else begin
      $display(" PASS : ALU_Control = %b , input_A = %h , input_B = %h | Expected = %h , Returned = %h " , ALU_Control, input_A , input_B, expected, result);
    end
    
  endtask
  
  
  
  initial begin
    
    //add with no overflow
    RegData = 32'h00000001;
    ImmExt = 32'h00000002;
    ALUSrc = 1;
    input_A = 32'h7FFFFFFE; 
    ALU_Control = 3'b000;
     #10;
    
    check_result( input_A + input_B);
    
    // ADD Test (Overflow)
        input_A = 32'h7FFFFFFF; 
	 ALU_Control = 3'b000; 
     ALUSrc = 0;
     RegData = 32'h00000001;
    ImmExt = 32'h00000002;
    #10;
    check_result(input_A + input_B);
    
    
    // SUB Test (Negative)
        input_A = 32'h00000002;
	ALUSrc = 1;
     RegData = 32'h00000001;
    ImmExt = 32'h00000002;  
	ALU_Control = 3'b001;
	 #10;
    check_result(input_A - input_B);


        // Test Zero Flag
        input_A = 32'h00000005;  
	ALU_Control = 3'b001; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000001;
	ALUSrc = 0;
	#10;
     check_result(input_A - input_B);
    $display("Zero Flag: %b" , Zero_Flag);
    
    // AND Test
        input_A = 32'h0000000F;
	ALU_Control = 3'b001; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 1;
	ALU_Control= 3'b010; 
	#10;
    check_result(input_A & input_B);
    
        // OR Test
        input_A = 32'h0000000F; 
	 ALU_Control = 3'b011; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 0;
	#10;
    check_result(input_A | input_B);
    
        // XOR Test
        input_A = 32'h0000000F; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 1;
	ALU_Control = 3'b100; 
	#10;
    check_result(input_A ^ input_B);
    
        // Shift Left Test
        input_A = 32'h00000001;  
	ALU_Control = 3'b101; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 1;
	#10;
    check_result(input_A << input_B[4:0]);
    

        // Shift Right Test
        input_A = 32'h00000008;
	 ALU_Control = 3'b110; 
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 0;
	#10;
    check_result(input_A >> input_B[4:0]);
    

        // SLT Test
        input_A = 32'h00000005; 
	ALU_Control = 3'b111;
	RegData = 32'h00000005;
	ImmExt = 32'h00000007;
	ALUSrc = 0;
	#10; 
    check_result( {{31{1'b0}}, input_A < input_B});
        // Stop Simulation
        $stop;
    
    
  end
  
  
endmodule
