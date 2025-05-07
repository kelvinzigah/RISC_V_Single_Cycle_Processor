`timescale 1ns/1ps

module pc_tb ();

    logic clk = 1;
    logic [1:0] PCSrc = 2'b00;                  // Control source
    logic [31:0] ExtendIn = 32'h00000000;       // Output from Extend Unit
    logic [31:0] ALU_out = 32'h11111111;        // JALR address /pc+4 stored in memory
    logic reset  = 0;

    wire [31:0] PCNext ;
    wire [31:0] PCPlus4 ;
    wire [31:0] PCTarget;
    wire[31:0] PC ;

    // DUTs
    PCPlus4 Plus4_dut (
        .PC(PC),
        .PCPlus4(PCPlus4)
    );

    PCTarget Target_dut (
        .ImmExt(ExtendIn),
        .PC(PC),
        .PCTarget(PCTarget)
    );

    PCNextMux PCMux_dut (
        .PCSrc(PCSrc),
        .jalr_address(ALU_out),
        .PCPlus4(PCPlus4),
        .PCTarget(PCTarget),
        .PCNext(PCNext)
    );

    PC PC_dut (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    // Clock
    always #5 clk = ~clk;

    // Simulation runtime
    initial begin
        #1000;
        $stop;
    end

    // Tests
    initial begin
        // Test 1: Reset
        reset = 1;
        ExtendIn = 32'h00000000;
        @(posedge clk);
        #10;
        $display("Test 1: PC = %h ", PC);
        if (PC !== 32'h00000000)
            $display("Case 1 : FAIL");
        else
            $display("Case 1 : PASS");

        // Test 2: PC updated with offset
        reset = 1;
        @(posedge clk);
        reset = 0;
        PCSrc = 2'b01;
        ExtendIn = 32'h16AB2D10;
        @(posedge clk);
        #10;
        $display("PC after offset update: %h", PC);
        if (PC !== 32'h16AB2D10)
            $display("Case 2 : FAIL");
        else
            $display("Case 2 : PASS");

        // Test 3: PC increment by 4
        $display(" Test 3: Current PC value: %h", PC);
	reset = 1;
	@(posedge clk);
	#2;
	reset = 0;
        PCSrc = 2'b01;
	ExtendIn = 32'h16AB2D10;
        @(posedge clk);
        #2;
	PCSrc = 2'b00;
	@(posedge clk);
        #2;
        $display("PC after increment update: %h", PC);
        if (PC !== 32'h16AB2D14)
            $display("Case 3 : FAIL");
        else
            $display("Case 3 : PASS");

        // Test 4: PC updated with jalr address
        $display(" Test 4: Current PC value: %h", PC);
	reset = 1;
	@(posedge clk);
	#2;
	reset = 0;
        PCSrc = 2'b10;
	ExtendIn = 32'h16AB2D10;
        @(posedge clk);
        #10;
        $display("PC after returning to jalr address: %h", PC);
        if (PC !== 32'h11111111)
            $display("Case 4 : FAIL");
        else
            $display("Case 4 : PASS");
    end

endmodule

