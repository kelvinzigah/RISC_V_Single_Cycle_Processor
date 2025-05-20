 `timescale 1ns/1ps

module topcore_tb;
  logic        clk;
  logic        reset;
  logic [31:0]	PC;
  logic [31:0] WriteData;
  logic [31:0] DataAddress;
  logic        MemWrite;
  

  // Instantiate the DUT
  SingleCoreTop dut (
    .clk        (clk),
    .reset      (reset),
    .WriteData  (WriteData),
    .DataAddress(DataAddress),
    .PC (PC),
    .MemWrite   (MemWrite)
	
  );

//checkers
//logic pass1, pass2;

//10ns clk
  initial clk = 0;
  always #5 clk = ~clk;



  // reset
  initial begin
  	reset <= 1; #22; reset <= 0;
  end

  always @(negedge clk)
 begin
	#1;
    if (PC  === 32'h00000014 ) begin
        $display(">>> PASS: Memory[%0d] <= %0d", DataAddress, WriteData);
	$finish;
      end 
  else if (PC  === 32'h0000004C ) begin
       		 $display(">>> Error Address Reached: Memory[%0d] <= %0d", DataAddress, WriteData);
		$finish;
  end
   
  end

initial begin
	#700;
	
	$display(">>> FAIL:");
        $display("    MemWrite    = %b", MemWrite);
        $display("    DataAddress = %0d", DataAddress);
        $display("    WriteData   = %0d", WriteData);
	
	$finish;	
end
endmodule

