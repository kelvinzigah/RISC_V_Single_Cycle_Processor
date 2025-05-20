`timescale 1ns/1ps

module ALU_TB;
  
  logic signed [31:0] A, B;
  logic [3:0]        ALU_ctrl;
  logic signed [31:0] result;
  logic              Zero_Flag, Negative_Flag, Carry_Flag, Overflow_Flag;

  // Instantiate your ALU under test
  ALU ALU_ut (
    .input_A       (A),
    .input_B       (B),
    .ALU_Control   (ALU_ctrl),  // if your ALU really only needs 3 bits
    .result        (result),
    .Zero_Flag     (Zero_Flag),
    .Negative_Flag (Negative_Flag),
    .Carry_Flag    (Carry_Flag),
    .Overflow_Flag (Overflow_Flag)
  );

  task automatic check(
    input string        name,
     input logic [31:0]  exp_r,
    input logic         exp_z,
    input logic         exp_n,
    input logic         exp_c,
    input logic         exp_v
  );
  begin
    if (result !== exp_r || Zero_Flag !== exp_z
     || Negative_Flag !== exp_n || Carry_Flag !== exp_c
     || Overflow_Flag !== exp_v) begin
      $error("%s FAILED: got result=%h ZNVC=%b%b%b%b, expected result=%h ZNVC=%b%b%b%b",
        name, result, Zero_Flag, Negative_Flag, Carry_Flag, Overflow_Flag,
              exp_r, exp_z, exp_n, exp_c, exp_v);
    end else begin
      $display("%s PASSED", name);
    end
  end
  endtask

  initial begin
    // ADD no overflow
    A        = 32'h7FFFFFFE; B = 32'h00000001; ALU_ctrl = 4'b0000; // ADDop
    #1; check("ADD no ovf", 32'h7FFFFFFF, 0,0,0,0);

    // ADD overflow
    A        = 32'h7FFFFFFF; B = 32'h00000001; ALU_ctrl = 4'b0000;
    #1; check("ADD ovf",    32'h80000000, 0,1,0,1);

    // SUB negative
    A        = 32'h00000002; B = 32'h00000003; ALU_ctrl = 4'b0001; // SUBop
    #1; check("SUB neg",    32'hFFFFFFFF, 0,1,0,0);

    // SUB zero+carry
    A        = 32'h00000005; B = 32'h00000005; ALU_ctrl = 4'b0001;
    #1; check("SUB zero",   32'h00000000, 1,0,1,0);

    // AND
    A        = 32'h0000000F; B = 32'h00000007; ALU_ctrl = 4'b0010;
    #1; check("AND",        32'h00000007, 0,0,0,0);

    // OR
    ALU_ctrl = 4'b0011;
    #1; check("OR",         32'h0000000F, 0,0,0,0);

    // XOR
    ALU_ctrl = 4'b0100;
    #1; check("XOR",        32'h00000008, 0,0,0,0);

    // SLL
    A        = 32'h00000001; B = 32'h00000002; ALU_ctrl = 4'b0101;
    #1; check("SLL",        32'h00000004, 0,0,0,0);

    // SRL
    A        = 32'h00000008; B = 32'h00000002; ALU_ctrl = 4'b0110;
    #1; check("SRL",        32'h00000002, 0,0,0,0);

    // SRA
    A        = 32'hFFFFFFF8; B = 32'h00000002; ALU_ctrl = 4'b1001;
    #1; check("SRA",        32'hFFFFFFFE, 0,1,0,0);

    // SLT: A < B signed?
    A        = 32'hFFFFFFFF; B = 32'h00000001; ALU_ctrl = 4'b0111;
    #1; check("SLT true",   32'h00000001, 0,0,0,0);
    A        = 32'h00000005; B = 32'h00000003; ALU_ctrl = 4'b0111;
    #1; check("SLT false",  32'h00000000, 1,0,0,0);

    // SLTU: A < B unsigned?
    A        = 32'hFFFFFFFF; B = 32'h00000001; ALU_ctrl = 4'b1000;
    #1; check("SLTU false", 32'h00000000, 1,0,0,0);
    A        = 32'h00000001; B = 32'hFFFFFFFF; ALU_ctrl = 4'b1000;
    #1; check("SLTU true",  32'h00000001, 0,0,0,0);

    $display(">> ALL TESTS COMPLETE");
    $finish;
  end
endmodule

