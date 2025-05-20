module instruction_cache (
    input  logic [31:0] address_input,
    output logic [31:0] data_output
);

always_comb begin
    case (address_input)
        32'h00000000: data_output = 32'h00000113; // addi x2,x0,0
        32'h00000004: data_output = 32'h00500193; // addi x3,x0,5
        32'h00000008: data_output = 32'h00000217; // auipc x4, 0
        32'h0000000C: data_output = 32'h00316663; // loop: bltu x2, x3, store
        32'h00000010: data_output = 32'h0180026F; // jal x4, function
        32'h00000014: data_output = 32'h00000063; // done: beq x0, x0, done
        32'h00000018: data_output = 32'h02410823; // store: sb 	x4, 0x30(x2)
        32'h0000001C: data_output = 32'h00110113; // addi x2, x2, 1
        32'h00000020: data_output = 32'h00121213; // slli x4, x4, 1
        32'h00000024: data_output = 32'hFE9FF06F; // jal x0, loop
        32'h00000028: data_output = 32'h03404283; // function: lbu x5, 0x34(x0)
        32'h0000002C: data_output = 32'h0002A313; // slti x6, x5, 0
        32'h00000030: data_output = 32'h03400283; // lb x5, 0x34(x0)
        32'h00000034: data_output = 32'h0002A393; // slti x7, x5, 0
        32'h00000038: data_output = 32'h00730A63; // beq x6, x7, error
        32'h0000003C: data_output = 32'h4012D293; // srai x5, x5, 1
        32'h00000040: data_output = 32'hFBF00313; // addi x6, x0, -65
        32'h00000044: data_output = 32'h00535463; // bge x6, x5, error
        32'h00000048: data_output = 32'h00020067; // jalr x0, 0(x4)
        32'h0000004C: data_output = 32'h00000063; // error: beq x0, x0, error
        default:      data_output = 32'h00000000; // don't care
    endcase
	$display(" Triggered Address: %h , Instruction %h" , address_input, data_output);
end


endmodule

