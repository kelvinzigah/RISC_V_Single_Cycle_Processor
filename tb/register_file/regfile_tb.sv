`timescale 1ns / 1ps

module regfile_tb;
    
    // Signals
    logic clk, write_en, reset;
    logic [4:0] write_ad, address1, address2;
    logic [31:0] data_in, data_out1, data_out2;
    
    // Instantiate the register file
    regfile DUT (
        .clk(clk),
        .write_en(write_en),
        .reset(reset),
        .write_ad(write_ad),
        .address1(address1),
        .address2(address2),
        .data_in(data_in),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );
    
    // Clock generation
    always #5 clk = ~clk;

    // Error flag
    bit test_failed = 0;
    integer i;
    integer j;
    
    // Initialize
    initial begin
        clk = 0;
        reset = 1;
        write_en = 0;
        data_in = 0;
        write_ad = 0;
        address1 = 0;
        address2 = 0;
       $monitor("reg[0] = %h", DUT.register[0]);
    end

    // Tests
    initial begin
        // Test 1: Check reset
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        test_failed = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if (DUT.register[i] !== 32'b0) begin
                test_failed = 1;
                break;
            end
        end
        $display("Test 1: %s", test_failed ? "FAIL" : "PASS");

        // Test 2: write_en = 0
        reset = 0;
        write_en = 0;
        write_ad = 5'd9;
        data_in = 32'hAF_AE_2E_03;
        address2 = 5'd9;
        @(posedge clk);
	
	
	$display(" Test 2, data_out2 = %h" ,data_out2);
        $display("Test 2: %s", data_out2 == 32'hAF_AE_2E_03 ? "FAIL" : "PASS");

        // Test 3: Write
        write_en = 1;
	write_ad = 5'd9;
        data_in = 32'hAF_AE_2E_03;
        address2 = 5'd9;
        @(posedge clk);
	#2;
	$display(" Test 3, data_out2 = %h" ,data_out2);
        $display("Test 3: %s", data_out2 == 32'hAF_AE_2E_03 ? "PASS" : "FAIL");

        // Test 4: Read from address1
        address1 = 5'd9;
        #5;
	$display(" Test 3, data_out1 = %h" ,data_out1);
        $display("Test 4: %s", data_out1 == 32'hAF_AE_2E_03 ? "PASS" : "FAIL");

        // Test 5: Read from unwritten reg
        address2 = 5'd15;
        #5;
        $display("Test 5: %s", data_out2 == 32'h0 ? "PASS" : "FAIL");

        // Test 6: Read after disabling write
        write_en = 0;
        address1 = 5'd9;
        @(posedge clk);
        $display("Test 6: %s", data_out1 == 32'hAF_AE_2E_03 ? "PASS" : "FAIL");

        // Test 7: Write/read two addresses
        write_en = 1;
        data_in = 32'hFF34A018;
        write_ad = 5'd20;
        @(posedge clk);
        data_in = 32'h1010AAEF;
        write_ad = 5'd30;
        @(posedge clk);
        address1 = 5'd20;
        address2 = 5'd30;
        #5;
        $display("Test 7: %s", (data_out1 == 32'hFF34A018 && data_out2 == 32'h1010AAEF) ? "PASS" : "FAIL");

        // Test 8: Reset and check zeroed registers
        reset = 1;
        @(posedge clk);
	#2;
	$display(" Test 8, data_out1 = %h" ,data_out1);
	$display(" Test 8, data_out2 = %h" ,data_out2);
        $display("Test 8: %s", (data_out1 == 0 && data_out2 == 0) ? "PASS" : "FAIL");

        // Test 9: Write + read before clock edge
        reset = 0;
        write_en = 1;
        data_in = 32'hABCDEFFF;
        write_ad = 5'd3;
        address1 = 5'd3;
        // no clk edge yet
        $display("Test 9: %s", data_out1 == 32'hABCDEFFF ? "FAIL" : "PASS");
    end

    // End simulation
    initial begin
        #300;
        $finish;
    end
    
endmodule

