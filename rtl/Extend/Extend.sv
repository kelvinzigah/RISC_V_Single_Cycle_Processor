	//======================== IMMEDIATE EXTENDER MODULE ========================//
module ImmExt(
    input logic [24:0] ImmExt_In,
    input logic [2:0] ImmSrc,
    output logic [31:0] ImmExt_Out
);

    // Extend to 32 bits, 31:7 + 0's so I don't have to rewrite the logic
    logic [31:0] ImmExt;
    assign ImmExt = {ImmExt_In[24:0], 7'b0000000};  

    always_comb begin
        case (ImmSrc)
            3'b000: // Type - I
                ImmExt_Out = {{20{ImmExt[31]}}, ImmExt[31:20]};
            3'b001: // Type - S
                ImmExt_Out = {{20{ImmExt[31]}}, ImmExt[31:25], ImmExt[11:7]};
            3'b010: // Type - B
                ImmExt_Out = {{20{ImmExt[31]}}, ImmExt[7], ImmExt[30:25], ImmExt[11:8], 1'b0};
            3'b011: // Type - U
                ImmExt_Out = {ImmExt[31:12], 12'b000000000000};
            3'b100: // Type - J
              ImmExt_Out = {{12{ImmExt[31]}},  ImmExt[19:12], ImmExt[20], ImmExt[30:21], 1'b0};
            default:
                ImmExt_Out = 32'b0;
        endcase
    end

endmodule
