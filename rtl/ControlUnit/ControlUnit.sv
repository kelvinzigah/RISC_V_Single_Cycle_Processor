module ControlUnit (
  input  logic        ZeroFlag,
  input  logic        NegativeFlag,
  input  logic        CarryFlag,
  input  logic        OverflowFlag,

  input  logic [6:0]  op,
  input  logic        func7_5,
  input  logic [2:0]  func3,

  output logic        DataType,
  output logic [1:0]  DataSize,

  output logic        RegWrite,
  output logic        ALUSrc,
  output logic        MemWrite,
  output logic [1:0]  PCSrc,
  output logic [3:0]  ALUcontrol,
  output logic [2:0]  ResultSrc,
  output logic [2:0]  ImmSrc
);

  // Internal signals
  logic        Branch;
  logic [1:0]  ALUop;
  logic        Jump;

  // Instantiate main decoder
  MainDecoder u_main (
    .ZeroFlag     (ZeroFlag),
    .NegativeFlag (NegativeFlag),
    .CarryFlag    (CarryFlag),
    .OverflowFlag (OverflowFlag),

    .op           (op),
    .func3        (func3),

    .DataType     (DataType),
    .DataSize     (DataSize),

    .RegWrite     (RegWrite),
    .ALUSrc       (ALUSrc),
    .MemWrite     (MemWrite),
    .Branch       (Branch),
    .ResultSrc    (ResultSrc),
    .ALUop        (ALUop),
    .PCSrc        (PCSrc),  // PCSrc is driven inside MainDecoder
    .Jump         (Jump),
    .ImmSrc       (ImmSrc)
  );

  // Instantiate ALU decoder
  ALUDecoder u_alu (
    .op         (op),
    .func7_5    (func7_5),
    .func3      (func3),
    .ALUop      (ALUop),
    .ALUcontrol (ALUcontrol)
  );

  // Self‑monitor for debug
  always_comb begin
    $display("CU In  : Z=%b N=%b C=%b V=%b  op=%b f7.5=%b f3=%b",
             ZeroFlag, NegativeFlag, CarryFlag, OverflowFlag,
             op, func7_5, func3);
    $display("CU Out : RegW=%b ALUSrc=%b MemW=%b ResSrc=%b ALUctrl=%b PCSrc=%b ImmSrc=%b",
             RegWrite, ALUSrc, MemWrite, ResultSrc, ALUcontrol, PCSrc, ImmSrc);
  end

endmodule
