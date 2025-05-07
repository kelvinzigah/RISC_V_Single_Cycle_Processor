module PC(
	input logic [31:0] PCNext,
	input logic clk,
	input logic reset,

	output logic [31:0] PC
);


	//logic [31:0] PCwire;

	always_ff @(posedge clk) begin

		if(reset)
			PC <= 32'h00000000;
		else begin 

			PC <= PCNext;
		end

	end




	//assign PC = PCwire;

endmodule


