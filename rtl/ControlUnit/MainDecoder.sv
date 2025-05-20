module MainDecoder(
  input  logic        ZeroFlag,
  input  logic        NegativeFlag,
  input  logic        CarryFlag,
  input  logic        OverflowFlag,

  input  logic [2:0]  func3,
  input  logic [6:0]  op,

  output logic        DataType,
  output logic [1:0]  DataSize,

  output logic        RegWrite,
  output logic        ALUSrc,
  output logic        MemWrite,
  output logic        Branch,
  output logic        Jump,
  output logic [2:0]  ResultSrc,
  output logic [1:0]  PCSrc,
  output logic [1:0]  ALUop,
  output logic [2:0]  ImmSrc
);

  // 16‑bit control word: { RegWrite, ImmSrc[2:0], ALUSrc, MemWrite, ResultSrc[2:0],
  //                         Branch, ALUop[1:0], Jump, DataType, DataSize[1:0] }
  logic [15:0] maincontrol;
  assign {
    RegWrite,
    ImmSrc,
    ALUSrc,
    MemWrite,
    ResultSrc,
    Branch,
    ALUop,
    Jump,
    DataType,
    DataSize
  } = maincontrol;

  logic [1:0] PCSrc_int;

  always_comb begin
    // Default:
    maincontrol = 16'b0;

    case (op)
      7'b0000011: begin // loads
        unique case (func3)
          3'b000: maincontrol = 16'b1_000_1_0_001_0_00_0_0_10; // lb, 
          3'b001: maincontrol = 16'b1_000_1_0_001_0_00_0_0_01; // lh
          3'b010: maincontrol = 16'b1_000_1_0_001_0_00_0_0_00; // lw
          3'b100: maincontrol = 16'b1_000_1_0_001_0_00_1_1_10; // lbu
          3'b101: maincontrol = 16'b1_000_1_0_001_0_00_1_0_01; // lhu
          default: maincontrol = 16'b0;
        endcase
      end

      7'b0100011: begin // stores
        unique case (func3)
          3'b000: maincontrol = 16'b0_001_1_1_000_0_00_0_0_10; // sb
          3'b001: maincontrol = 16'b0_001_1_1_000_0_00_0_0_01; // sh
          3'b010: maincontrol = 16'b0_001_1_1_000_0_00_0_0_00; // sw
          default: maincontrol = 16'b0;
        endcase
      end

      7'b0110011: // R‑type
        maincontrol = 16'b1_000_0_0_000_0_10_0_0_00;

      7'b1100011: // branches (BEQ, BNE, BLT, …)
        maincontrol = 16'b0_010_0_0_000_1_01_0_0_00;

      7'b0010011: // I‑type ALU
        maincontrol = 16'b1_000_1_0_000_0_10_0_0_00;

      7'b1101111: // JAL
        maincontrol = 16'b1_100_0_0_010_0_00_1_0_00;

      7'b1100111: // JALR
        maincontrol = 16'b1_000_1_0_010_0_00_1_0_00;

      7'b0110111: // LUI
        maincontrol = 16'b1_011_0_0_011_0_00_0_0_00;

      7'b0010111: // AUIPC
        maincontrol = 16'b1_011_0_0_100_0_00_0_0_00;

      default:
        maincontrol = 16'b0;
    endcase

    // PCSrc logic (including branches)
    if      (op == 7'b1100111 && Jump)        PCSrc_int = 2'b10; // JALR
    else if (op == 7'b1101111 && Jump)        PCSrc_int = 2'b01; // JAL
    else if (op == 7'b1100011) begin          // conditional branch
      unique case (func3)
        3'b000: PCSrc_int = ZeroFlag    ? 2'b01 : 2'b00; // BEQ
        3'b001: PCSrc_int = !ZeroFlag   ? 2'b01 : 2'b00; // BNE
        3'b100: PCSrc_int = (NegativeFlag ^ OverflowFlag) ? 2'b01 : 2'b00; // BLT
        3'b101: PCSrc_int = !(NegativeFlag ^ OverflowFlag)? 2'b01 : 2'b00; // BGE
        3'b110: PCSrc_int = !CarryFlag   ? 2'b01 : 2'b00; // BLTU
        3'b111: PCSrc_int = (CarryFlag & ~ZeroFlag)? 2'b01 : 2'b00; // BGEU
        default: PCSrc_int = 2'b00;
      endcase
    end
    else
      PCSrc_int = 2'b00;
  end

  assign PCSrc = PCSrc_int;

endmodule
