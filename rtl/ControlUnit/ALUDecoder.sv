module ALUDecoder (
    input  logic [6:0] op,
    input  logic func7_5,
    input  logic [2:0] func3,
    input  logic [1:0] ALUop,
    output logic [2:0] ALUcontrol

);

always_comb
    case (ALUop)
        2'b00: ALUcontrol = 3'b000; // add
        2'b01: ALUcontrol = 3'b001; // subtract
        2'b10: begin // R-type or I-type ALU
            case (func3)
                3'b000: begin
                    case (op)
                        7'b0010011: ALUcontrol = 3'b000; // ADDI
                        7'b0110011: ALUcontrol = (func7_5) ? 3'b001 : 3'b000; // SUB or ADD
                        default:    ALUcontrol = 3'bxxx;
                    endcase
                end
                3'b010: ALUcontrol = 3'b111; // SLT
                3'b001: ALUcontrol = 3'b101; // SLL
                3'b101: ALUcontrol = 3'b110; // SRL
                3'b110: ALUcontrol = 3'b011; // OR
                3'b111: ALUcontrol = 3'b010; // AND
                3'b100: ALUcontrol = 3'b100; // XOR
                default: ALUcontrol = 3'bxxx;
            endcase
        end
        default: ALUcontrol = 3'bxxx;
    endcase

endmodule

