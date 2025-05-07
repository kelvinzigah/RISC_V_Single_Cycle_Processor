module ALU (
input logic signed [31:0] input_A, 
input logic signed [31:0]input_B,  
input logic [2:0] ALU_Control, 
output logic signed [31 : 0] result,
output logic Zero_Flag 
);

  // Declare signals
  logic [31:0] Sum, diff, AND_result, OR_result, XOR_result, ShiftL_result, ShiftR_result;
  logic Cout, adder_Cout, sub_Cout, Overflow_Flag;
  logic SLT;
  
  //change if needed
  logic adder_Cin = 0;


  
  
  //adder
  assign {adder_Cout, Sum} = input_A + input_B + adder_Cin;
  

  //subtracter
  assign {sub_Cout , diff} = input_A - input_B ;
  
  
  
  // Logical operations
  assign AND_result = input_A & input_B;
  assign OR_result  = input_A | input_B;
  assign XOR_result = input_A ^ input_B;
  assign ShiftL_result = input_A << input_B[4:0];
  assign ShiftR_result = input_A >> input_B[4:0];
  
   // SLT operation
  assign SLT = input_A < input_B;

  // Overflow flag logic
  assign Overflow_Flag = (ALU_Control == 3'b000) ? 
                         ((input_A[31] == input_B[31]) && (Sum[31] != input_A[31])) :
                         (ALU_Control == 3'b001) ? 
                         ((input_A[31] != input_B[31]) && (diff[31] != input_A[31])) : 
                         1'b0;

 

  // Carry-out logic (MUX)
  assign Cout = (ALU_Control == 3'b000) ? adder_Cout :
                (ALU_Control == 3'b001) ? sub_Cout : 
                1'b0;

  // Zero flag
  assign Zero_Flag = (result == 0);

  
  
  
  
  
  
  
  // ALU operation selection
  always_comb begin
    case (ALU_Control)
      3'b000: result = Sum;
      3'b001: result = diff;
      3'b010: result = AND_result;
      3'b011: result = OR_result;
      3'b100: result = XOR_result;
      3'b101: result = ShiftL_result; 
      3'b110: result = ShiftR_result; 
      3'b111: result = { {31{1'b0}}, SLT };  
      default: result = 0;
    endcase
  end

endmodule





