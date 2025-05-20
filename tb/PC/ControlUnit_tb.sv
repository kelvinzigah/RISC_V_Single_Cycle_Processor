`timescale 1ns / 1ps

module ControlUnit_tb;

  

  // Inputs to DUT
  logic ZeroFlag;
  logic [6:0] op;
  logic func7_5;
  logic [2:0] func3;

  // Outputs from DUT
  logic RegWrite;
  logic ALUSrc;
  logic MemWrite;
  logic [1:0] PCSrc;
  logic [2:0] ALUcontrol;
  logic [1:0] ResultSrc; 
  logic [2:0] ImmSrc;

  // Instantiate DUT
  ControlUnit dut (
    .ZeroFlag(ZeroFlag),
    .op(op),
    .func7_5(func7_5),
    .func3(func3),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .PCSrc(PCSrc),
    .ALUcontrol(ALUcontrol),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc)
  );

  // Task to check control output
  task check_control;
    input [6:0] test_op;
    input        test_func7_5;
    input [2:0]  test_func3;
    input        test_ZeroFlag;
    input [1:0]  exp_PCSrc;
    input [2:0]  exp_ALUcontrol;
    input        exp_RegWrite;
    input        exp_ALUSrc;
    input        exp_MemWrite;
    input [1:0]  exp_ResultSrc;
    input [2:0]  exp_ImmSrc;

    begin
      op = test_op;
      func7_5 = test_func7_5;
      func3 = test_func3;
      ZeroFlag = test_ZeroFlag;
      #1;

      if (PCSrc !== exp_PCSrc ||
          ALUcontrol !== exp_ALUcontrol ||
          RegWrite !== exp_RegWrite ||
          ALUSrc !== exp_ALUSrc ||
          MemWrite !== exp_MemWrite ||
          ResultSrc !== exp_ResultSrc ||
          ImmSrc !== exp_ImmSrc) begin
        $display("❌ FAIL: op=%b func3=%b func7_5=%b | Got: PCSrc=%b ALUctrl=%b RegW=%b ALUSrc=%b MemW=%b ResultSrc=%b ImmSrc=%b",
                 test_op, test_func3, test_func7_5, PCSrc, ALUcontrol, RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc);
      end else begin
        $display("✅ PASS: op=%b func3=%b func7_5=%b", test_op, test_func3, test_func7_5);
      end
    end
  endtask

  initial begin
    // Test cases: (op, func7_5, func3, ZeroFlag, PCSrc, ALUcontrol, RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc)
    check_control(7'b0000011, 1'b0, 3'b010, 0, 2'b00, 3'b000, 1, 1, 0, 2'b01, 3'b000); // lw
    check_control(7'b0100011, 1'b0, 3'b010, 0, 2'b00, 3'b000, 0, 1, 1, 2'b00, 3'b001); // sw
    check_control(7'b0110011, 1'b0, 3'b000, 0, 2'b00, 3'b000, 1, 0, 0, 2'b00, 3'b000); // add
    check_control(7'b0110011, 1'b1, 3'b000, 0, 2'b00, 3'b001, 1, 0, 0, 2'b00, 3'b000); // sub
    check_control(7'b0010011, 1'b0, 3'b000, 0, 2'b00, 3'b000, 1, 1, 0, 2'b00, 3'b000); // addi
    check_control(7'b1100011, 1'b0, 3'b000, 1, 2'b01, 3'b001, 0, 0, 0, 2'b00, 3'b010); // beq taken
    check_control(7'b1100011, 1'b0, 3'b000, 0, 2'b00, 3'b001, 0, 0, 0, 2'b00, 3'b010); // beq not taken
    check_control(7'b1101111, 1'b0, 3'b000, 0, 2'b01, 3'b000, 1, 0, 0, 2'b10, 3'b100); // jal
    check_control(7'b1100111, 1'b0, 3'b000, 0, 2'b10, 3'b000, 1, 1, 0, 2'b10, 3'b000); // jalr
    check_control(7'b0110111, 1'b0, 3'b000, 0, 2'b00, 3'b000, 1, 0, 0, 2'b11, 3'b011); // lui

    $finish;
  end

endmodule

