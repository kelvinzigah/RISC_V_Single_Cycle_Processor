`timescale 1ns/1ps

module topcore_tb;
  logic        clk;
  logic        reset;
  logic [31:0] WriteData;
  logic [31:0] DataAddress;
  logic        MemWrite;

  // Instantiate the DUT
  SingleCoreTop dut (
    .clk        (clk),
    .reset      (reset),
    .WriteData  (WriteData),
    .DataAddress(DataAddress),
    .MemWrite   (MemWrite)
  );

//10ns clk
  initial clk = 0;
  always #5 clk = ~clk;

  // Task : Reset pulse
  task automatic do_reset();
    begin
      reset = 1;
      repeat (2) @(posedge clk);
      reset = 0;
    end
  endtask

  // reset
  initial begin
    do_reset();
  end

  always @(posedge clk) begin
    if (MemWrite) begin
      #1; // give outputs a moment to settle
      if (DataAddress === 32'd100 && WriteData === 32'd102400) begin
        $display(">>> PASS: Memory[%0d] <= %0d", DataAddress, WriteData);
      end else begin
        $display(">>> FAIL:");
        $display("    MemWrite    = %b", MemWrite);
        $display("    DataAddress = %0d", DataAddress);
        $display("    WriteData   = %0d", WriteData);
      end
      $finish;
    end
  end
endmodule

