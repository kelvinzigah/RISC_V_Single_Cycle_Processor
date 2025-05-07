module datamem(
input logic clk,
input logic WriteEn,
input logic [31:0] address,
input logic [31:0] datain,

output logic [31:0] dataout


);



//memory array
logic [31:0] RAM [63:0]; //64 memory locations

assign dataout = RAM[address[31:2]]; //word alligned?


always_ff @(posedge clk) begin
	if(WriteEn) begin
		RAM[address[31:2]] <= datain;
	$monitor(" Memory at address %h , gets data: %h" , address, datain);
	end
	//RAM[24] = 32'hDEADBEEF;  //testing datapath
end




endmodule
