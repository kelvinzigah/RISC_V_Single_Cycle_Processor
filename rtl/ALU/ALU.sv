module ALU (
input logic signed [31:0] input_A, 
input logic signed [31:0]input_B,  
input logic [3:0] ALU_Control, 


output logic signed [31:0] result,
//flags
output logic Zero_Flag,
output logic Overflow_Flag,
output logic Negative_Flag,
output logic Carry_Flag
);

  // Declare signals
  logic [31:0] AND_result, OR_result, XOR_result, SLL_result, SRL_result, SLT_result, SRA_result, SLTU_result;
	
  //add and sub result
   logic [32:0] wide_sum;


  //operation codes
localparam logic [3:0]
    ADDop  = 4'b0000,
    SUBop  = 4'b0001,
    ANDop  = 4'b0010,
    ORop   = 4'b0011,
    XORop  = 4'b0100,
    SLLop  = 4'b0101,
    SRLop  = 4'b0110,
    SLTop  = 4'b0111,
    SLTUop = 4'b1000,
    SRAop  = 4'b1001;
	
  


  //computing wide sum for add/sub

always_comb begin
	case(ALU_Control)
		ADDop: wide_sum = {1'b0, input_A} + {1'b0, input_B};
		SUBop: wide_sum = {1'b0, input_A} + {1'b0, ~input_B} +1;
		default: wide_sum = 32'h0;
	endcase
end
  
  
  
  // Logical operations
  assign AND_result = input_A & input_B;
  assign OR_result  = input_A | input_B;
  assign XOR_result = input_A ^ input_B;
  assign SLL_result = input_A << input_B[4:0];
  assign SRL_result = input_A >> input_B[4:0];
  assign SLT_result = (input_A < input_B) ? 32'b1 : 32'b0;
  assign SLTU_result = ($unsigned(input_A) < $unsigned(input_B)) ? 32'b1 : 32'b0;
  assign SRA_result = $signed(input_A) >>> input_B[4:0]; // arithmetic right
  
 

  // Overflow flag logic
  assign Overflow_Flag = (ALU_Control == ADDop) ? 
                         ((input_A[31] == input_B[31]) && (wide_sum[31] != input_A[31])) :
                         (ALU_Control == SUBop) ? 
                         ((input_A[31] != input_B[31]) && (wide_sum[31] != input_A[31])) : 
                         1'b0;

 //carry flag logic
  assign Carry_Flag = (ALU_Control == ADDop || ALU_Control == SUBop) ? wide_sum[32] : 1'b0;


 // Zero flag
  assign Zero_Flag = (result == 0);

// Negative flag
  assign Negative_Flag = result[31];

 
  
  
  // ALU operation selection
  always_comb begin
    unique case (ALU_Control)
      ADDop:  result = wide_sum[31:0];
      SUBop:  result = wide_sum[31:0];
      ANDop:  result = AND_result;
      ORop:   result = OR_result;
      XORop:  result = XOR_result;
      SLLop:  result = SLL_result;
      SRLop:  result = SRL_result;
      SLTop:  result = SLT_result;
      SLTUop: result = SLTU_result;
      SRAop:  result = SRA_result;
      default: result = '0;
    endcase
  end

endmodule





