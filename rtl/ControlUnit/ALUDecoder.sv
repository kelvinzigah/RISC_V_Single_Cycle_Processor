module ALUDecoder (
  input  logic [6:0] op,
  input  logic       func7_5,
  input  logic [2:0] func3,
  input  logic [1:0] ALUop,
  output logic [3:0] ALUcontrol
);

  always_comb begin
    unique case (ALUop)
      2'b00: ALUcontrol = 4'b0000; // ADD
      2'b01: ALUcontrol = 4'b0001; // SUB
      2'b10: begin
        unique case (func3)
          3'b000: // ADDI / ADD / SUB
            ALUcontrol = (op == 7'b0110011 && func7_5) ? 4'b0001 : 4'b0000; // SUB or ADD
          3'b001: ALUcontrol = 4'b0101; // SLL/SLLI
          3'b010: ALUcontrol = 4'b0111; // SLT/SLTI
          3'b011: ALUcontrol = 4'b1000; // SLTU/SLTIU
          3'b100: ALUcontrol = 4'b0100; // XOR/XORI
          3'b101: // SRL/SRLI vs SRA/SRAI
            ALUcontrol = func7_5 ? 4'b1001 : 4'b0110;  //SRA/SRAI or SRL/SRLI
          3'b110: ALUcontrol = 4'b0011; // OR/ORI
          3'b111: ALUcontrol = 4'b0010; // AND/ANDI
          default: ALUcontrol = 4'bxxxx;
        endcase
      end
      default: ALUcontrol = 4'bxxxx;
    endcase
  end

endmodule
