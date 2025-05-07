module regfile (
input logic clk, 
input logic write_en , 
input logic reset, 
input logic [4:0] write_ad, 
input logic [4:0]address1, 
input logic [4:0]address2, 
input logic [31:0] data_in , 
output logic [31:0] data_out1, 
output logic [31:0]data_out2
);


//register array
logic [31:0] register [31:0];



//writing on positive edge 
always_ff @( posedge clk )begin
	
	// register[4] = 32'hffffffff; //testing datapath
	// register[7] = 32'hDEADBEEA; //testing datapath
    //reseting all registers to 0
    if(reset)begin
      for(integer i = 0; i < 32 ; i = i + 1)begin
            register[i] <= 32'b0;
        end
    end 

//writing to the register
    else if(write_en && write_ad !== 5'd0) register[write_ad] <= data_in;

	
$monitor(" register= %h gets : %h", write_ad , data_in);
	
end


//reading is done asynchronously
assign data_out1 = register[address1];
assign data_out2 = register[address2];


endmodule
