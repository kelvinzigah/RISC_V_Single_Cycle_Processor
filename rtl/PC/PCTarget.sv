module PCTarget (
input logic [31:0] ImmExt,
input logic [31:0] PC,

output logic [31:0] PCTarget
);


assign PCTarget = ImmExt + PC;

endmodule
