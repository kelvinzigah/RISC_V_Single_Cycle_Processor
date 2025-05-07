`timescale 1ns / 1ps

module instructionmem_tb;

logic [31:0] address_input;
logic [31:0] data_output;


//instantiation

instruction_cache IMdut(
.address_input(address_input),
.data_output(data_output)

);


initial begin

address_input = 32'h00000004;
#5;
address_input = 32'h0000000C;
#5;
address_input = 32'h00000020;
#5;



$monitor("Address in: %h , data out: %h " , address_input, data_output);

end


endmodule
