`timescale 1ns/1ps

module dmem_tb;

  // Clock & reset
  logic        clk;
  logic        rst;       

  // DUT ports
  logic        we;
  logic [1:0]  datasize;
  logic        datatype;     // '0'=signed, '1'=unsigned for loads
  logic [31:0] a;
  logic [31:0] wd;
  logic [31:0] rd;

  // Instantiate datamem
  datamem dut (
    .clk     (clk),
    .WriteEn (we),
    .address (a),
    .datain  (wd),
    .datatype(datatype),
    .reset   (rst),
    .datasize(datasize),
    .dataout (rd)
  );

  // 100MHz clock
  initial clk = 0;
  always #5 clk = ~clk;

  // helper to check
  task automatic check(string name, logic [31:0] exp);
    if (rd !== exp)
      $error("%0s FAILED: rd = %08h (expected %08h)", name, rd, exp);
    else
      $display("%0s PASS: rd = %08h", name, rd);
  endtask

  initial begin
    // reset pulse
    rst = 1;
    repeat (2) @(posedge clk);
    rst = 0;
    @(posedge clk);

    // Case 1: Write word at 0x04, read back
    we       = 1;
    datasize = 2'b00;
    a        = 32'h00000004;
    wd       = 32'h1234_5678;
    @(posedge clk);
    we = 0;
    @(posedge clk);
    check("Case1 (word write/rd)", 32'h1234_5678);

    // Case 2: with WE=0, cannot overwrite
    we       = 0;
    a        = 32'h00000008;
    wd       = 32'hDEAD_BEEF;
    @(posedge clk);
    check("Case2 (no-we write)", 32'h0000_0000);

    // Case 3-6:half-word writes at 0x40 and 0x42
    datasize = 2'b01;
    we       = 1;
    a  = 32'h00000040; wd = 32'h1212_EFEF; @(posedge clk);
    a  = 32'h00000042; wd = 32'hEFEF_1212; @(posedge clk);
    we = 0;

    // signed read @0x40 -> expect 0xFFFF_EFEF
    datatype = 1'b0; a = 32'h00000040; @(posedge clk);
    check("Case3 (half-signed @40)", 32'hFFFF_EFEF);

    // unsigned read @0x40 -> 0x0000_EFEF
    datatype = 1'b1; @(posedge clk);
    check("Case4 (half-unsigned @40)", 32'h0000_EFEF);

    // signed read @0x42 -> 0x0000_1212
    datatype = 1'b0; a = 32'h00000042; @(posedge clk);
    check("Case5 (half-signed @42)", 32'h0000_1212);

    // unsigned read @0x42 → 0x0000_1212
    datatype = 1'b1; @(posedge clk);
    check("Case6 (half-unsigned @42)", 32'h0000_1212);

    // Case 7-11: Byte writes 
    datasize = 2'b10;
    we       = 1;
    a = 32'h00000050; wd = 32'hFFFF_0040; @(posedge clk);
    a = 32'h00000051; wd = 32'hFFFF_0041; @(posedge clk);
    a = 32'h00000052; wd = 32'hFFFF_0042; @(posedge clk);
    a = 32'h00000053; wd = 32'hFFFF_0043; @(posedge clk);
    a = 32'h00000054; wd = 32'hFFFF_0044; @(posedge clk);
    we = 0;
    datatype = 1'b1;

    a = 32'h00000050; @(posedge clk); check("Case7 (byte@50)", 32'h00000040);
    a = 32'h00000051; @(posedge clk); check("Case8 (byte@51)", 32'h00000041);
    a = 32'h00000052; @(posedge clk); check("Case9 (byte@52)", 32'h00000042);
    a = 32'h00000053; @(posedge clk); check("Case10(byte@53)",32'h00000043);
    a = 32'h00000054; @(posedge clk); check("Case11(byte@54)",32'h00000044);

    // Case 12: misaligned read at 0x05 (from word @0x04)
    a = 32'h00000005; @(posedge clk);
    // original word was 0x12345678, byte@05 = 0x56
    check("Case12 (misaligned @05)", 32'h00000056);

    $display("=== ALL TESTS COMPLETE ===");
    $finish;
  end
endmodule

